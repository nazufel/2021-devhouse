# kubernetes.tf

# file to create a GKE cluster and node pools

# --------------------------------------------------------------------------- #

# create a GKE cluster
resource "google_container_cluster" "devhouse" {
  name     = "devhouse"
  location = var.DEVHOUSE_2021_GCP_REGION

  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.devhouse.self_link
  subnetwork               = google_compute_subnetwork.kubernetes.self_link

  depends_on = [
    google_dns_managed_zone.devhouse_private_zone,
    google_compute_network.devhouse,
    google_compute_subnetwork.kubernetes,
  ]
}

# create a node pool for the above cluster
resource "google_container_node_pool" "devhouse" {
  name       = "devhouse"
  location   = var.DEVHOUSE_2021_GCP_REGION
  cluster    = google_container_cluster.devhouse.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

  }

  depends_on = [
    google_dns_managed_zone.devhouse_private_zone,
    google_compute_network.devhouse,
    google_compute_subnetwork.kubernetes,
    google_container_cluster.devhouse
  ]

}
#EOF