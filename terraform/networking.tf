# networking.tf

# creates the project networks and subnets

# --------------------------------------------------------------------------- #

# create a network in GCP
resource "google_compute_network" "devhouse" {
  name                    = "devhouse"
  auto_create_subnetworks = false
}

# create a subnet for kubernetes
resource "google_compute_subnetwork" "kubernetes" {
  name          = "kubernetes"
  project       = var.DEVHOUSE_2021_GCP_PROJECT
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.devhouse.self_link

  depends_on = [
    google_compute_network.devhouse
  ]
}

# create a subnet for app servers
resource "google_compute_subnetwork" "app_servers" {
  name          = "servers"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.devhouse.self_link
  depends_on = [
    google_compute_network.devhouse
  ]
}

# create a cloud router
resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.devhouse.self_link
  depends_on = [
    google_compute_network.devhouse
  ]
}

# create cloud nat
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.DEVHOUSE_2021_GCP_PROJECT
  region     = var.DEVHOUSE_2021_GCP_REGION
  router     = google_compute_router.router.name
  depends_on = [
    google_compute_network.devhouse,
    google_compute_router.router
  ]
}

# create firewall rules for the gcp network
resource "google_compute_firewall" "app_servers" {
  name     = "app-servers"
  project  = var.DEVHOUSE_2021_GCP_PROJECT
  network  = google_compute_network.devhouse.name
  priority = 65534

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = [
      "22",
      "53",
      "80",
    ]
  }

  depends_on = [
    google_compute_network.devhouse
  ]
}
#EOF