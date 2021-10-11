variable "DEVHOUSE_2021_GCP_PROJECT" {}

provider "google" {
  project = var.DEVHOUSE_2021_GCP_PROJECT
  region  = "us-east4"
  zone    = "us-east4-a"
}