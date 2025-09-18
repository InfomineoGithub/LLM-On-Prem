terraform {
  backend "gcs" {
    bucket  = "large-models"
    prefix  = "terraform/state"
  }
}