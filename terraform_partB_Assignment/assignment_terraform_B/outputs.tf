output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "endpoint" {
  value = data.google_container_cluster.mycluster.endpoint
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.master.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.master.endpoint
  description = "GKE Cluster Host"
}
