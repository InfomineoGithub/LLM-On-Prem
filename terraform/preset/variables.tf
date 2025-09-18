variable "project_id" {
  description = "The ID of the Google Cloud project where all resources will be created."
  type        = string
}

# -----------------------------------------------------------------------------
# GCS Backend Bucket Variable
# -----------------------------------------------------------------------------

variable "gcs_bucket_name" {
  description = "The globally unique name for the GCS bucket for Terraform state."
  type        = string
}