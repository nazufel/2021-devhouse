# dns.tf

# file to creat dns zones

# --------------------------------------------------------------------------- #

# create a devhouse.systems private DNS zone
resource "google_dns_managed_zone" "devhouse_private_zone" {
  name        = "devhouse-systems"
  dns_name    = "devhouse.systems."
  description = "Private DNS Zone for devhouse"
  project     = var.DEVHOUSE_2021_GCP_PROJECT

  visibility = "private"

  # expose this DNS zone
  private_visibility_config {
    networks {
      network_url = google_compute_network.devhouse.self_link
    }
  }

  depends_on = [
    google_compute_network.devhouse
  ]
}
#EOF