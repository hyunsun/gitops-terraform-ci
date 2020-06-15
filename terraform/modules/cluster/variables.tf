variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
}

variable "members" {
  description = "Username of the cluster members."
  type        = list(string)
  default     = []
}

variable "rke_config" {
  description = "RKE configurations."
  type        = object({
      k8s_version          = string
      k8s_pod_range        = string
      k8s_cluster_ip_range = string
      cluster_domain       = string
      kube_dns_cluster_ip  = string
  })
  default = {
    k8s_version          = ""
    k8s_pod_range        = ""
    k8s_cluster_ip_range = ""
    cluster_domain       = ""
    kube_dns_cluster_ip  = ""
  }
}

variable "nodes" {
  description = "List of the cluster nodes."
  type       = map(object({
    user     = string
    password = string
    host     = string
    roles    = string
  }))
  default = {}
}

variable "projects" {
  description = "List of projects."
  type        = map
  default     = {}
}
