resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = "service" 
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "testapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "testapp"
        }
      }
      spec {
        container {
          image = "nginx"
          name  = "nginx-container"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "nginx_svc" {
  metadata {
    name      = "nginxservice"
    namespace = "service"
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}
