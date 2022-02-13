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

resource "google_compute_instance" "vm_instance" {
  name         = "mc-server"
  machine_type = "f1-micro"
  zone         = "europe-west1-b"
  tags         = ["mc", "terraform"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      type = "pd-ssd"    
    }	
  }

  scratch_disk {
    device_name = "minecraft-disk"
    type = "ssd-pd"
    interface = "SCSI"


  network_interface {
    network = "mc-net"
    subnetwork = "default"
    access_config {
    }
  }
}

