terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source  = "terraform-providers/rancher2"
      version = "<= 1.8.3"
    }
  }
}

locals {
  namespaces = distinct([
    for app in var.apps: app.target_namespace
  ])
}

resource "rancher2_project" "project" {
  name        = var.name
  cluster_id  = var.cluster_id
  description = var.description
}

resource "rancher2_project_role_template_binding" "member" {
  for_each = toset(var.members)

  name             = each.value
  project_id       = rancher2_project.project.id
  role_template_id = "project-member"
  user_id          = each.value
}

resource "rancher2_namespace" "namespaces" {
  for_each = toset(local.namespaces)

  name       = each.value
  project_id = rancher2_project.project.id
}

module "apps" {
  for_each = var.apps

  source           = "../app"
  project_id       = rancher2_project.project.id
  name             = each.value.name
  catalog_name     = each.value.catalog_name
  template_name    = each.value.template_name
  template_version = each.value.template_version
  target_namespace = each.value.target_namespace
  values_yaml      = each.value.values_yaml

  depends_on = [rancher2_namespace.namespaces]
}
