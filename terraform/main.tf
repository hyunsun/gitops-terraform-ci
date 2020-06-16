terraform {
  required_version = ">= 0.13"
  backend "gcs" {
    bucket  = "aether-terraform-bucket"
    prefix  = "dev/state"
  }
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

locals {
  values_yaml = base64encode(templatefile(
    "${path.module}/values.yml.tpl",
    {
      omec_cp_docker_reg      = var.omec_cp_docker_reg
      omec_cp_hss_image_tag   = var.omec_cp_hss_image_tag
      omec_cp_mme_image_tag   = var.omec_cp_mme_image_tag
      omec_cp_spgwc_image_tag = var.omec_cp_spgwc_image_tag

      edge_mon_docker_reg = var.edge_mon_docker_reg
      edge_mon_image_tag  = var.edge_mon_image_tag
    }))
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
          template_name    = "edge-monitoring"
          template_version = var.edge_mon_chart_ver
          values_yaml      = local.values_yaml
        }
      }
    },
    connectivity_service = {
      name = "ConnectivityService"
      apps = {
        omec_control_plane = {
          name             = "omec-control-plane"
          catalog_name     = "cord"
          target_namespace = "omec"
          template_name    = "omec-control-plane"
          template_version = var.omec_cp_chart_ver
          values_yaml      = local.values_yaml
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
