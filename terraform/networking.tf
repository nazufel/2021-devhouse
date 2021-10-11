# networking.tf

# creates the project networks and subnets

# --------------------------------------------------------------------------- #

###############################################################################
###                             NETWORKS                                    ###
###############################################################################
resource "google_compute_network" "devhouse" {
  name                    = "devhouse"
  auto_create_subnetworks = false
}

###############################################################################
###                              SUBETS                                     ###
###############################################################################

resource "google_compute_subnetwork" "kubernetes" {
  name          = "kubernetes"
  project       = var.DEVHOUSE_2021_GCP_PROJECT
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.devhouse.self_link
}


resource "google_compute_subnetwork" "app_servers" {
  name          = "servers"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.devhouse.self_link
}

### Cloud Router ###

# Central
resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.devhouse.self_link
}

### NAT ###

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.DEVHOUSE_2021_GCP_PROJECT
  region     = var.DEVHOUSE_2021_GCP_REGION
  router     = google_compute_router.router.name
}