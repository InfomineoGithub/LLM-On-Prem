resource "google_storage_bucket" "tf_state" {
  name          = var.gcs_bucket_name
  project       = var.project_id
  
  location      = "US"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}