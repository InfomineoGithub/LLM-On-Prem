variable "credentials_file_path" {
  description = "The path to the GCP credentials JSON file used to authenticate Terraform."
  type        = string
}

variable "gcs_bucket_name" {
  description = "The globally unique name for the GCS bucket for Terraform state."
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Cloud project where the service account will be created."
  type        = string
}

variable "service_account_id" {
  description = "The desired ID for the new service account. This will be used to construct the email address of the service account."
  type        = string
}

variable "service_account_display_name" {
  description = "The display name for the service account."
  type        = string
}

variable "key_output_path" {
  description = "The local path where the service account key file will be saved."
  type        = string
  default     = "service-account-key.json"
}

variable "service_account_description" {
  description = "A descriptive text for the service account."
  type        = string
}