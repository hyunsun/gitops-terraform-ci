variable "rancher_url" {
  type = string
}

variable "rancher_access_key" {
  type = string
}

variable "rancher_secret_key" {
  type = string
}

variable "edge_mon_chart_ver" {
  type    = string
  default = "latest"
}

variable "edge_mon_docker_reg" {
  type    = string
  default = "docker.io/hyunsunmoon"
}

variable "edge_mon_image_tag" {
  type    = string
  default = "latest"
}

variable "omec_cp_chart_ver" {
  type    = string
  default = "latest"
}

variable "omec_cp_docker_reg" {
  type    = string
  default = "docker.io/omecproject"
}

variable "omec_cp_hss_image_tag" {
  type    = string
  default = "latest"
}

variable "omec_cp_mme_image_tag" {
  type    = string
  default = "master-latest"
}

variable "omec_cp_spgwc_image_tag" {
  type    = string
  default = "central-cp-multi-upfs-latest"
}
