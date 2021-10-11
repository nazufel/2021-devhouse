# app_servers.tf

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


resource "google_service_account" "devhouse" {
  project = var.DEVHOUSE_2021_GCP_PROJECT
  account_id   = "devhouse"
  display_name = "Devhouse Service Account"
}

resource "google_compute_instance" "app_server" {
  name         = "devhouse-app-server"
  machine_type = "e2-medium"
  zone         = "${var.DEVHOUSE_2021_GCP_REGION}-a"

  tags = [
    "devhouse", 
    "2021", 
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
}