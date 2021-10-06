# infra.tf

# terraform file to build dev house 2021 talk  infra

# --------------------------------------------------------------------------- #

# init the provider and version
terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.22.0"
    }
  }
}

variable "DEVHOUSE_INFRA_TOKEN" {}

# configure the linode provider with API key sourced from environment
provider "linode" {
  token = var.DEVHOUSE_INFRA_TOKEN
}

# build the linode instance

resource "linode_instance" "web" {
    label = "simple_instance"
    image = "linode/ubuntu18.04"
    region = "us-central"
    type = "g6-standard-1"
    authorized_keys = ["ssh-rsa AAAA...Gw== user@example.local"]
    root_pass = "terr4form-test"

    group = "foo"
    tags = [ "foo" ]
    swap_size = 256
    private_ip = true
}

# --------------------------------------------------------------------------- #
#EOF