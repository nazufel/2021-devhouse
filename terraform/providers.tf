# provider.tf

# file to init the provider

# --------------------------------------------------------------------------- #

# init the google provider
provider "google" {
  project = var.DEVHOUSE_2021_GCP_PROJECT
  region  = var.DEVHOUSE_2021_GCP_REGION
}
#EOF