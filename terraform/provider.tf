terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  credentials = file(var.credentials_file_path)
}