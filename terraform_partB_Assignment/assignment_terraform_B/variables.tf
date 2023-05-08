variable "project_id" {
  description = "project id"
  type = string
  default = "dataloop-candidate-environment"
}

variable "cluster_name" {
  description  = "This will be the name of the cluster"
  type = string
  default = "gkeclusteratul"
}

variable "kubernetes_version" {
  default = "1.27.1"
}


variable "p_key" {
default = "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCp/YuOGuxAw6c6\nmjBQ0gV9iD3og6IhaEsolTp1BlZcd8/xPvB+vSVAEQWT1qRCw5D3rFFuxoRC6or9\nCCgUdashLIxEYGUUG+JdxIW3FeOa4WNht0Z7y20JqcA2NRngzRvapgu/Jb0d4eY9\nSGwXFMRccBViDokfK5JwSqrFoMhpumdlFMjvZa4FtDZGEiy76690mI2xSez4RyH1\nf85XwH53x/fsOiFhYhoX5xTNdjEOJ386yW2yVnxNGOM1HJO+jepv7xOUD+fnm4an\nf908/P4l850EnuXLI7/bHrD0Np+RaKU2K8U9XqOhxhdVhbOhJC6MJ/5sNWHDjVqS\n5GzOgLA7AgMBAAECggEAALMC/xeaFIHgARGDLpIEzWostKNWTDb7+B6BB/MX+hxJ\nkVQbwWOwXrliTWfCtCcWac5RWcwhj5y0ifb+H+8bPUgml3M8JtmO8Q4Vq2Fr9+DN\ndrQBx2o3cd+f3yrUzxERBTRXk9CN41w6B/W1EMAHCPt0ttZoUtvMiaeuafzXDh8+\nw2qe0OjADa2LALintaUCIB4R3e3slWXKpqA7OyT+WGxprl69Z38uoBrhFJAswXHg\nrsibiWdT//f2Zvaj4Hor0fMu3tgi/upGfl/xGnnbfLd2sdbNCfb49X+BqNJwWbe9\nNeIWNtt2fQ8Qt+bHB/4PdZAaYDTXb8sJRgwfePXzhQKBgQDjpcOsR2G1JZPf2a0B\nc/ZDYuGtnPZIfMvCKEVZaujKz7aLIDpUYkN4/WW9nqFCXYlFKTuHRr2Xb9Of28D2\nVJK/b6cX/hejrJ8qgs5UicV6LTcPGEmxK6sx4n+yzPEeM2o7fza66aa5v64QYXel\nl+43UR7MDPFmLJ6ZAD0iEJKkFQKBgQC/KXYYirO2xA3JpMs6+AYHancMghn6LGUe\nlnCg6TGY17qq4ZFs0gylp004R6hYe3gYaxhOMURe51ipCqPuGmN9bQA8Mi0KaS7+\nWqQw6hBH+ymcsh+3smdj7dcb7fqILir2Zj4SVZUvxP6wwkT105g68fsk/JsXgxCh\n9ExSClqHDwKBgHEReUHNZotZsbviWxq4pR1NNLhNmMniKjYyWFeUUTHCv3EUvcQB\n1m92tJzc+E2FNdQDKc0D5tEbuunQdWQkF4s8AqtZChbCe3/a3m6Ay3Pml01JC/kS\nroIldLWzMyOD+AS7J8zolmX1/ZenQY0fDDOvd/NzjkbobJGj27lar+sNAoGBAKRs\nUynU07NWes2AM1YrU3Q5fOCDXzixyuA+Ye3l5kUi+WpVzrIdEcfCWUcZS5Gf0bKf\nGy7WbYp7zuTHRC1fAUg240bjmZ4kzsj0ydlQ2mQvgqFHDMUCbK+lOarKTP2pSEbb\ntnQqrMGD3dXHo20WbQ/2ZyBvLi9RCpNi/+ppAWi9AoGAZfb5kPMqa6z6SBhKMoDw\nUTZU+VfQFwZcbzkPz9SPeGp8pVT1pribLOas+f0q1hlD2edmGoq06VK0uJsebAhj\nlpl0xNvxgd4/TOM44+2mjwHh+q0C2EBvZhb0szIao4+4H8RM9NmE1fFerMmtcESN\nuWZdquZ2B9Cr999SSw7pb0g=\n-----END PRIVATE KEY-----\n"
}

variable "workers_count" {
  default = "3"
}

variable "email" {
 default = "terraform-sa@dataloop-candidate-environment.iam.gserviceaccount.com" 
}

variable "region" {
  description = "region"
  default = "us-central1"
}

variable "zone" {
  description = "dc_zone"
  default = "us-central1-a"
}

variable "gke_username" {
  default     = "gcpuser"
  description = "gketest"
}

variable "gke_password" {
  default     = "gcppass"
  description = "gketestpass"
}

variable "gke_num_nodes" {
  default     = 5
  description = "number of gke nodes"
}

variable "gke_namespaces" {
  type = any
  default = [
         [
            "service",
            "service_ns"
         ],
         [
            "monitoring",
            "monitoring_ns"
         ]
         ]
}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "kube-version" {
  type = string
  default = "36.0.2"
}


