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

resource "google_compute_network" "mc-net" {
  name = "mc-net"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "mc-fw-rules" {
    name    = "mc-fw-rules"
    description = "Allowing necessary ports for Minecraft Server"
    priority = "1000"
    direction = "INGRESS"
    network = "projects/wave32-webhelp-adriab/regions/europe-west1-b/subnetworks/mc-net"
    source_ranges = ["0.0.0.0/0"]
    source_tags = ["mc"]
    allow {
        protocol = "tcp"
        ports    = ["22", "25565"]
    }
    depends_on = [google_compute_network.mc-net]
}

resource "google_compute_disk" "minecraft-disk" {
  name = "minecraft-disk"
  type = "pd-ssd"
  zone = "europe-west1-b"
  size = "50"
}

resource "google_compute_instance" "mc-server" {
  name         = "mc-server"
  machine_type = "e2-standard-2"
  zone         = "europe-west1-b"
  tags         = ["mc", "terraform"]

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
  depends_on = [google_compute_disk.minecraft-disk, google_compute_network.mc-net]
}

