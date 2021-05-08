resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-to-gateway-instance"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["gateway-instance"]

  source_ranges = ["0.0.0.0/0"]

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow_consul_port_for_gke_node" {
  name    = "allow-consul-port-for-gke-node"
  network = google_compute_network.vpc.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  target_tags = ["${var.project_id}-gke"]

  source_ranges = [google_container_cluster.primary.private_cluster_config[0].master_ipv4_cidr_block]
}
