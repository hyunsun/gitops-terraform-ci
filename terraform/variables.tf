variable "rancher_url" {
  type = string
}

variable "rancher_access_key" {
  type = string
}

variable "rancher_secret_key" {
  type = string
}

variable "edge_monitoring" {
  type = object({
    chart_version = string
    server_image  = string
  })
}
