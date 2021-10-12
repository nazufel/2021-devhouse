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

  depends_on = [
    google_compute_network.devhouse
  ]
}


resource "google_compute_subnetwork" "app_servers" {
  name          = "servers"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.devhouse.self_link
  depends_on = [
    google_compute_network.devhouse
  ]
}

### Cloud Router ###

# Central
resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.devhouse.self_link
  depends_on = [
    google_compute_network.devhouse
  ]
}

### NAT ###

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
      "9042",
      "9142",
      "7000",
      "7001",
      "7199",
      "10000",
      "9180",
      "9100",
      "9160",
      "10001",
      "5609",
      "56090",
      "22",
      "53",
    ]
  }

  depends_on = [
    google_compute_network.devhouse
  ]
}