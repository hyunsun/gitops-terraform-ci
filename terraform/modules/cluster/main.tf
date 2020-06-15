terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source  = "terraform-providers/rancher2"
      version = "<= 1.8.3"
    }
  }
}

# create cluster members with standard user role
#module "members" {
#  for_each = toset(var.members)
#
#  source      = "../user"
#  username    = each.value
#  global_role = "user"
#}
#
# create RKE cluster and add nodes to it
#module "rke_cluster" {
#  source       = "../rke"
#  cluster_name = var.cluster_name
#  rke_config   = var.rke_config
#  nodes        = var.nodes
#  members      = var.members
#}
#
#resource "rancher2_cluster_sync" "cluster-wait" {
#  cluster_id = module.rke_cluster.id
#}

data "rancher2_cluster" "cluster" {
  name = var.cluster_name
}

# create managed projects and applications
module "projects" {
  for_each = var.projects

  source      = "../project"
  cluster_id  = data.rancher2_cluster.cluster.id
  name        = each.value.name
  apps        = each.value.apps
}
