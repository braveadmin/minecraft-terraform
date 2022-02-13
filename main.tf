terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
}

resource "google_compute_network" "vpc_network" {
  name = "mc-net"
  auto_create_subnetworks = true
}

resource "google_compute_disk" "minecraft-disk" {
  name = "minecraft-disk"
  type = "pd-ssd"
  zone = "europe-west1-b"
  size = "50"
}

resource "google_compute_instance" "vm_instance" {
  name         = "mc-server"
  machine_type = "e2-standard-2"
  zone         = "europe-west1-b"
  tags         = ["mc", "terraform", "allow-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type = "pd-ssd"    
    }	
  }

  attached_disk {
    source = "minecraft-disk"
    device_name = "minecraft-disk"

  } 

  network_interface {
    network = "mc-net"
    subnetwork = "mc-net"    
    access_config {
    }
  }
}

