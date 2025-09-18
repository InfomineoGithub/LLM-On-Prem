# -----------------------------------------------------------------------------
# GKE Cluster - Control Plane
# -----------------------------------------------------------------------------

resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.zone

  # We will create our own node pool, so we remove the default one.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Versioning and release channel
  release_channel {
    channel = "REGULAR"
  }
  min_master_version = "1.33.4-gke.1036000"

  # Networking
  network    = "projects/${var.project_id}/global/networks/default"
  subnetwork = "projects/${var.project_id}/regions/us-central1/subnetworks/default"
  ip_allocation_policy {
    # This empty block enables VPC-native networking (ip-alias)
  }

  # Security
  master_auth {
    client_certificate_config {
      issue_client_certificate = false # Corresponds to --no-enable-basic-auth
    }
  }
  master_authorized_networks_config {} # Corresponds to --no-enable-master-authorized-networks
  enable_shielded_nodes = true
  security_posture_config {
    mode = "BASIC"
    
  }

  # Add-ons
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

  # Logging, Monitoring, and Prometheus
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  deletion_protection = false
}

# -----------------------------------------------------------------------------
# Node Pool - Single Pool with A2 Machine Type and GPU
# -----------------------------------------------------------------------------

resource "google_container_node_pool" "primary_gpu_pool" {
  name     = "primary-gpu-pool"
  project  = var.project_id
  cluster  = google_container_cluster.primary.name
  location = google_container_cluster.primary.location

  initial_node_count = 2 # As requested in your gcloud command
  max_pods_per_node  = 110

  # Node lifecycle management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  # Node configuration
  node_config {
    # CORRECTED: Using the A2 machine type for A100 GPUs.
    machine_type = "a2-highgpu-2g"
    image_type   = "COS_CONTAINERD"
    disk_size_gb = 100
    disk_type    = "pd-balanced"

    # This block confirms the GPU type for the A2 machine.
    guest_accelerator {
      type  = "nvidia-tesla-a100"
      count = 2
      gpu_driver_installation_config {
        gpu_driver_version = "LATEST"
      }
    }

    # Required for GPU nodes

    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}