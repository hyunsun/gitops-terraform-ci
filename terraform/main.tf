terraform {
  required_version = ">= 0.13"
#  backend "gcs" {
#    bucket  = "aether-terraform-bucket"
#    prefix  = "dev/state"
#  }
  required_providers {
    rancher2 = {
      source  = "terraform-providers/rancher2"
      version = "<= 1.8.3"
    }
  }
}

provider "rancher2" {
  api_url = var.rancher_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

module "dev-central" {
  source = "./modules/cluster"

  cluster_name = "gitops-dev-central"
  projects = {
    edge_monitoring = {
      name = "Monitoring"
      apps = {
        edge_monitoring = {
          name             = "edge-monitoring"
          catalog_name     = "gitops-terraform-test"
          target_namespace = "edge-monitoring"
          template_name    = "aether-monitoring"
          template_version = var.edge_monitoring.chart_version
          values_yaml      = base64encode(templatefile("${path.module}/edge-monitoring.yml.tpl", var.edge_monitoring))
        }
      }
    }
  }
}

#module "cluster" "dev-edge" {
#  source = "./modules/cluster"
#
#  cluster_name = "gitops-dev"
#  projects = {
#    connectivity-service = {
#
#    }
#  }
#}
