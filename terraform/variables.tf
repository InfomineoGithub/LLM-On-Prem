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

variable "credentials_file_path" {
  description = "The path to the GCP credentials JSON file used to authenticate Terraform."
  type        = string
}

# -----------------------------------------------------------------------------
# GCS Backend Bucket Variable
# -----------------------------------------------------------------------------

variable "gcs_bucket_name" {
  description = "The globally unique name for the GCS bucket for Terraform state."
  type        = string
}

# -----------------------------------------------------------------------------
# Service Account Variables
# -----------------------------------------------------------------------------

variable "service_account_id" {
  description = "The desired ID for the new service account. This will be used to construct the email address of the service account."
  type        = string
}

variable "service_account_display_name" {
  description = "The display name for the service account."
  type        = string
}

variable "service_account_description" {
  description = "A descriptive text for the service account."
  type        = string
}

variable "key_output_path" {
  description = "The local path where the service account key file will be saved."
  type        = string
  default     = "service-account-key.json"
}

# -----------------------------------------------------------------------------
# GKE Cluster Variable
# -----------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name for the GKE Standard cluster."
  type        = string
  default     = "gke-a2-gpu-cluster"
}