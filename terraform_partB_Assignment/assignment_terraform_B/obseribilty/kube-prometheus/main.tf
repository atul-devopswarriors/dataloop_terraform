resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stackr"
  namespace  = "monitoring"
  version    = var.kube-version
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  set {
   name = "service.type"
   value = "NodePort"
  }
}
