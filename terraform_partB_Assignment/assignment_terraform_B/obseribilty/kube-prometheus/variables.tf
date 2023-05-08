variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "kube-version" {
  description = "Please Select The Value Based on the updated kube_version"
  default = "36.0.2"
}
