terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "default" {
  name       = "light-key"
  public_key = file(var.ssh_public_key)
}

# droplet (VM)
resource "digitalocean_droplet" "vm" {
  name   = var.vm_name
  region = var.region

  size = var.vm_size

  image = "ubuntu-24-04-x64"

  ssh_keys = [
    digitalocean_ssh_key.default.id
  ]

  tags = ["terraform", "dev"]

  # bootstrap docker + tools on first boot
  user_data = file("${path.module}/../../scripts/cloud-init.sh")
}

resource "digitalocean_firewall" "web_firewall" {
  name = "light-firewall"

  droplet_ids = [digitalocean_droplet.vm.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }
}
