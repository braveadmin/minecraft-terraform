output "network" {
  value = google_compute_network.mc-net.name
}

output "instance" {
  value = google_compute_instance.mc-server.name
}

output "ip" {
  value = google_compute_instance.mc-server.network_interface.0.network_ip
}

