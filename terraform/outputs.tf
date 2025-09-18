output "gcs_bucket_name" {
  value = var.gcs_bucket_name
}

output "service_account_email" {
  description = "The email address of the created service account."
  value       = google_service_account.service_account.email
}

output "key_file_path" {
  description = "The path to the generated service account key file."
  value       = local_file.service_account_key_file.filename
}