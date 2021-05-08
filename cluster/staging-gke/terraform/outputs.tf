output "zone" {
  value       = var.zone
  description = "GCloud Zone"
}

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "gateway_instance_name" {
  value       = google_compute_instance.gateway_instance.name
  description = "Gateway-instance Name"
}

output "gateway_instance_host" {
  value       = google_compute_instance.gateway_instance.network_interface[0].network_ip
  description = "Gateway-instance Host"
}

output "gateway_instance_external_ip" {
  value       = google_compute_instance.gateway_instance.network_interface[0].access_config[0].nat_ip
  description = "Gateway-instance External IP"
}

output "ingress_ip" {
  value       = google_compute_global_address.ingress-ip.address
  description = "Ingress IP"
}
