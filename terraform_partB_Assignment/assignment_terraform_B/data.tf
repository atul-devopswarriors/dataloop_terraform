data "google_container_engine_versions" "supported" {
  location       = var.region
  version_prefix = var.kubernetes_version
}

data "google_container_cluster" "mycluster" {
  name     = "gkeclusteratul"
  project  = var.project_id
  location = var.region

  depends_on = [
    google_container_node_pool.master_pool
  ]
}

data "google_service_account" "object_viewer" {
  account_id = "111141078973693471686"
}

