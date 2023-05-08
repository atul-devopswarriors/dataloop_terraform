# GKE cluster
resource "google_container_cluster" "master" {
  name     = var.cluster_name
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "master_pool" {
  name       = google_container_cluster.master.name
  location   = var.region
  cluster    = google_container_cluster.master.name
  node_count = var.gke_num_nodes

  node_config {
   service_account = data.google_service_account.this.email
   oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
   ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "var.cluster_name"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
