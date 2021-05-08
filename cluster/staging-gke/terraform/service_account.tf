resource "google_service_account" "gateway_instance" {
  account_id   = "gateway-instance"
  display_name = "Service Account for gateway-instance"
}

#resource "google_project_iam_custom_role" "enable_kubectl" {
#  role_id = "EnableKubectl"
#  title   = "Enable Kubectl"
#
#  permissions = [
#    "container.clusters.get",
#    "container.pods.list",
#    "container.namespaces.create"
#  ]
#}

resource "google_project_iam_binding" "bind_enable_kubectl" {
  # role = google_project_iam_custom_role.enable_kubectl.id
  role = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.gateway_instance.email}",
  ]
}
