# -----------------------------------------------------------------------------
# GCP Project & Authentication
# -----------------------------------------------------------------------------

variable "project_id" {
  description = "The ID of the Google Cloud project where all resources will be created."
  type        = string
}

variable "zone" {
  description = "The GCP zone to create resources in (e.g., 'us-central1-c'). Must support A100 GPUs."
  type        = string
  default     = "us-central1-c"
}

variable "gke_region" {
  description = "The GCP region for the GKE cluster and subnetwork."
  type        = string
  default     = "us-central1"
}

# -----------------------------------------------------------------------------
# Service Account Variables
# -----------------------------------------------------------------------------

variable "service_account_id" {
  description = "The desired ID for the new service account. This will be used to construct the email address of the service account."
  type        = string
  default     = "skypilot-sa"
}

variable "service_account_display_name" {
  description = "The display name for the service account."
  type        = string
  default     = "Skypilot Service Account"
}

variable "service_account_description" {
  description = "A descriptive text for the service account."
  type        = string
  default     = "Service Account Associated with Skypilot."
}

variable "key_output_path" {
  description = "The local path where the service account key file will be saved."
  type        = string
  default     = "skypilot-sa.json"
}

# -----------------------------------------------------------------------------
# Networking Variables
# -----------------------------------------------------------------------------

variable "network_name" {
  description = "The name for the VPC network."
  type        = string
  default     = "skypilot-vpc"
}

variable "subnetwork_name" {
  description = "The name for the GKE subnetwork."
  type        = string
  default     = "skypilot-subnet"
}

variable "subnetwork_cidr_range" {
  description = "The primary IP address range for the subnetwork."
  type        = string
  default     = "10.10.0.0/20"
}

variable "pods_cidr_range" {
  description = "The secondary IP address range for GKE pods."
  type        = string
  default     = "10.20.0.0/16"
}

variable "services_cidr_range" {
  description = "The secondary IP address range for GKE services."
  type        = string
  default     = "10.30.0.0/20"
}

# -----------------------------------------------------------------------------
# GKE Cluster Variables
# -----------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name for the GKE Standard cluster."
  type        = string
  default     = "skypilot"
}

variable "gke_release_channel" {
  description = "The release channel for the GKE cluster."
  type        = string
  default     = "REGULAR"
}

# -----------------------------------------------------------------------------
# GKE Cluster Autoscaling Variables
# -----------------------------------------------------------------------------

variable "enable_cluster_autoscaling" {
  description = "Whether to enable cluster-level autoscaling."
  type        = bool
  default     = true
}

variable "autoscaling_min_cpu_cores" {
  description = "The minimum number of CPU cores for the cluster autoscaler."
  type        = number
  default     = 0
}

variable "autoscaling_max_cpu_cores" {
  description = "The maximum number of CPU cores for the cluster autoscaler."
  type        = number
  default     = 16
}

variable "autoscaling_min_memory_gb" {
  description = "The minimum memory in GB for the cluster autoscaler."
  type        = number
  default     = 0
}

variable "autoscaling_max_memory_gb" {
  description = "The maximum memory in GB for the cluster autoscaler."
  type        = number
  default     = 256
}


# -----------------------------------------------------------------------------
# GKE Node Pool Variables
# -----------------------------------------------------------------------------

variable "gpu_node_pool_name" {
  description = "The name for the GPU node pool."
  type        = string
  default     = "skypilot-node-pool"
}

variable "gpu_node_count" {
  description = "The fixed number of nodes in the GPU node pool."
  type        = number
  default     = 2
}

variable "gpu_machine_type" {
  description = "The machine type for the GPU nodes (e.g., a2-highgpu-2g)."
  type        = string
  default     = "a2-highgpu-2g"
}

variable "gpu_disk_size_gb" {
  description = "The boot disk size in GB for each GPU node."
  type        = number
  default     = 100
}

variable "gpu_disk_type" {
  description = "The boot disk type for each GPU node."
  type        = string
  default     = "pd-balanced"
}

variable "gpu_accelerator_type" {
  description = "The type of GPU accelerator to attach (e.g., nvidia-tesla-a100)."
  type        = string
  default     = "nvidia-tesla-a100"
}

variable "gpu_accelerator_count" {
  description = "The number of GPUs to attach to each node."
  type        = number
  default     = 2
}

variable "node_oauth_scopes" {
  description = "The set of Google API scopes to be made available on all of the nodes."
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/trace.append",
  ]
}