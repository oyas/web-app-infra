resource "google_compute_instance" "gateway_instance" {
  name         = "gateway-instance"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["gateway-instance"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {}
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.gateway_instance.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    preemptible = true
    automatic_restart = false
  }
}
