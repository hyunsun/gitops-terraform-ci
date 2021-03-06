variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
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
}

variable "nodes" {
  description = "List of the cluster nodes."
  type        = map(object({
    user     = string
    password = string
    host     = string
    roles    = string
  })) 
  default = {}
}

variable "members" {
 description = "List of the cluster members." 
 type        = list(string)
 default     = []
}

