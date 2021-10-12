# app_servers.tf

# create app servers

# --------------------------------------------------------------------------- #

# define variables that are local to the module
locals {
  boot_disk_size = 250
  boot_disk_type = "pd-ssd"
  metadata_startup_script = <<EOF
#/bin/sh

echo "STATUS: updating apt cache..."
sudo apt-get update

echo "STATUS: updating packages..."
sudo apt-get upgrade
sudo apt-get dist-upgrade

echo "STATUS: installing base dependencies..."
sudo apt-get install -y python3.8
EOF
}

# create a service account for the app servers
resource "google_service_account" "devhouse" {
  project = var.DEVHOUSE_2021_GCP_PROJECT
  account_id   = "devhouse"
  display_name = "Devhouse Service Account"
}

# create a GCP instance for an app server
resource "google_compute_instance" "app_01" {
  name         = "app-01"
  machine_type = "e2-medium"
  zone         = "${var.DEVHOUSE_2021_GCP_REGION}-a"

  tags = [
    "devhouse", 
    "app-server",
    "demo"
  ]

  boot_disk {
    auto_delete = true
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = local.boot_disk_size
      type  = local.boot_disk_type
    }
  }


  network_interface {
    network    = google_compute_network.devhouse.name
    subnetwork = google_compute_subnetwork.app_servers.name
  }

  metadata = {
    environment = "devhouse"
    ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCY1fhNvh29dI1qGAmZrRNr8W2DmNtqOQYlVvssduAl1kfuhLQ5h2eI9AtIiNtQ4ej9rb732cUV5pZph7TwkFgMISKy0lcI4IZdLUBnfS7o7IAB0jInCPYtTrGPykDno937q7dzjDFEdV8MIrmAGPLgz+aGesVHxU5oUPlNGaMrGf9rBkt9qz31o6VEaH7DAjR59aWXox4oS/2Db8HveaSAGQ3HJmAKMQ0GutI8vpLO7mNA2CAtRASgdG4oyvSaCTDRzoJJFVQC/nheCYcwmzLKtTs24saxhikDv89Dt7NxmE/juh6YtpKhuaaewx8wY7JLtZlrYAkq86Hur4Hx995hUW0sN3oezWnmdnVe+v59XIKAjvOuALTChxvTDlqMh+5ss2BNQgEyzLx+kGLG98iHOiOa2Lc9mtyyKFruy1fjLZcwZkfsj6x/PYgGux1FeZN3zITcN6OMNQngaSLBfzmSJv1wNNBlNbQGspDruPcgOY9zfMviJjDL6NpgxcHGVks= rross@gloomwalker"
  }

  metadata_startup_script = local.metadata_startup_script

  scheduling {
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.devhouse.email
    scopes = ["cloud-platform"]
  }

    depends_on = [
    google_dns_managed_zone.devhouse_private_zone,
    google_compute_network.devhouse,
    google_compute_subnetwork.app_servers,
    google_service_account.devhouse
  ]
}

# create a DNS entry for the app server
resource "google_dns_record_set" "app_01" {
  name    = format("${google_compute_instance.app_01.name}.%s", google_dns_managed_zone.devhouse_private_zone.dns_name)
  project = var.DEVHOUSE_2021_GCP_PROJECT
  type    = "A"
  # 30 second TTL
  ttl          = 30
  managed_zone = google_dns_managed_zone.devhouse_private_zone.name
  rrdatas      = [google_compute_instance.app_01.network_interface.0.network_ip]

  depends_on = [
    google_dns_managed_zone.devhouse_private_zone,
    google_compute_instance.app_01
  ]
}
#EOF