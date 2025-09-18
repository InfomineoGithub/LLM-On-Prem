terraform {
  backend "gcs" {
    #bucket  = ""
    #prefix  = "terraform/state"
  }

  #required_providers {
    #google = {
      #source  = "hashicorp/google"
      #version = ">= 3.5.0"
    #}
    #local = {
      #source  = "hashicorp/local"
      #version = ">= 1.4.0"
    #}
  #}
}