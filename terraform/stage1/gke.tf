# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

# Creates the VPC network
resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false # Best practice: create subnetworks manually
}

# Creates the subnetwork for the GKE cluster
resource "google_compute_subnetwork" "gke_subnetwork" {
  project                  = var.project_id
  name                     = var.subnetwork_name
  ip_cidr_range            = var.subnetwork_cidr_range
  region                   = var.gke_region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = var.pods_cidr_range
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = var.services_cidr_range
  }
}

# -----------------------------------------------------------------------------
# GKE Cluster
# -----------------------------------------------------------------------------

# Creates the GKE cluster control plane
resource "google_container_cluster" "primary" {
  project             = var.project_id
  name                = var.cluster_name
  location            = var.zone
  deletion_protection = false

  # Best practice: create a dedicated node pool and remove the default one.
  remove_default_node_pool = true
  initial_node_count       = 1

  # --- Networking ---
  # These now refer to the resources created above.
  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.gke_subnetwork.id

  # Corresponds to --enable-ip-alias
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }
  # Corresponds to --no-enable-intra-node-visibility
  enable_intranode_visibility = false
  # Corresponds to --default-max-pods-per-node
  default_max_pods_per_node = 110

  # --- Version and Maintenance ---
  # Corresponds to --release-channel "regular"
  # When using release channels, GKE manages the specific version for you.
  release_channel {
    channel = var.gke_release_channel
  }

  # --- Addons ---
  # Corresponds to --addons HttpLoadBalancing,HorizontalPodAutoscaling,GcePersistentDiskCsiDriver
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  # --- Cluster Autoscaling ---
  # This enables autoscaling for the cluster itself, allowing it to manage different node pools.
  # This is separate from node pool autoscaling.
  cluster_autoscaling {
    enabled             = var.enable_cluster_autoscaling
    # autoscaling_profile = "OPTIMIZE_UTILIZATION"

    # resource_limits {
    #   resource_type = "cpu"
    #   minimum       = var.autoscaling_min_cpu_cores
    #   maximum       = var.autoscaling_max_cpu_cores
    # }
    # resource_limits {
    #   resource_type = "memory"
    #   minimum       = var.autoscaling_min_memory_gb
    #   maximum       = var.autoscaling_max_memory_gb
    # }
  }

  # --- Security ---
  # Corresponds to --no-enable-basic-auth
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  # --no-enable-master-authorized-networks is the default behavior, so no configuration is needed.

  # Corresponds to --security-posture=standard and --workload-vulnerability-scanning=disabled
  security_posture_config {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_DISABLED"
  }

  # --- Logging & Monitoring ---
  # Corresponds to --logging=SYSTEM,WORKLOAD
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  # Corresponds to --monitoring=SYSTEM and --enable-managed-prometheus
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }
}

# Creates the primary node pool for the GKE cluster
resource "google_container_node_pool" "gpu_node_pool" {
  project  = var.project_id
  name     = var.gpu_node_pool_name
  cluster  = google_container_cluster.primary.id
  location = var.zone

  # Set a fixed number of nodes instead of using autoscaling.
  node_count = var.gpu_node_count

  # Corresponds to --node-locations
  node_locations = [
    var.zone,
  ]

  # --- Node Pool Management ---
  # Corresponds to --enable-autorepair and --enable-autoupgrade
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  # Corresponds to --max-surge-upgrade and --max-unavailable-upgrade
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  # --- Node Configuration ---
  node_config {
    # Changed machine type to an A2 instance, which is required for A100 GPUs.
    # The a2-highgpu-2g machine type comes with two H100 GPUs attached.
    machine_type = var.gpu_machine_type
    image_type   = "COS_CONTAINERD"
    disk_size_gb = var.gpu_disk_size_gb
    disk_type    = var.gpu_disk_type

    # Updated the GPU configuration to use two NVIDIA H100 GPUs.
    # GKE will automatically install the necessary NVIDIA drivers.
    guest_accelerator {
      type  = var.gpu_accelerator_type
      count = var.gpu_accelerator_count
    }

    # Add a taint to ensure only pods that request GPUs are scheduled on these nodes.
    # Pods will need a corresponding "toleration" to run here.
    taint {
      key    = "nvidia.com/gpu"
      value  = "present"
      effect = "NO_SCHEDULE"
    }

    # Corresponds to --metadata disable-legacy-endpoints=true
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Corresponds to --scopes
    oauth_scopes = var.node_oauth_scopes

    # Corresponds to --enable-shielded-nodes
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}