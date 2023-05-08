data "kubernetes_namespace" "ns_1" {
 metadata {
      name = "service"
 }
}
data "kubernetes_namespace" "ns_2" {
 metadata {
   name = "monitoring"
 }
}
