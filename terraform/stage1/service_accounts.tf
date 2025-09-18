resource "google_service_account" "service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  description  = var.service_account_description
  project      = var.project_id
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}

resource "local_file" "service_account_key_file" {
  content  = base64decode(google_service_account_key.service_account_key.private_key)
  filename = var.key_output_path
}