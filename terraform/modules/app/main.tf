terraform {
  required_providers {
    rancher2 = {
      source  = "terraform-providers/rancher2"
      version = "<= 1.8.3"
    }
  }
}



resource "rancher2_app" "app" {
  project_id       = var.project_id
  name             = var.name
  target_namespace = var.target_namespace
  catalog_name     = var.catalog_name
  template_name    = var.template_name
  template_version = (var.template_version == "latest" ? null : var.template_version)
  values_yaml      = var.values_yaml
}
