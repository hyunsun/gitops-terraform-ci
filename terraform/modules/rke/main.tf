terraform {
  required_version = ">= 0.13"
  required_providers {
    rancher2 = {
      source  = "terraform-providers/rancher2"
      version = "<= 1.8.3"
    }
  }
}

resource "rancher2_cluster" "cluster" {
  name = var.cluster_name
  rke_config {
    kubernetes_version = var.rke_config.k8s_version
    monitoring {
      provider = "none"
    }
    network {
      plugin = "calico"
    }
    services {
      kube_api {
        service_node_port_range = "2000-36767"
        service_cluster_ip_range = var.rke_config.k8s_cluster_ip_range
        extra_args = {
          feature-gates = "SCTPSupport=True"
        }
      }
      kubelet {
        cluster_domain = var.rke_config.cluster_domain
        cluster_dns_server = var.rke_config.kube_dns_cluster_ip
        fail_swap_on = false
        extra_args = {
          cpu-manager-policy = "static"
          kube-reserved = "cpu=500m,memory=256Mi"
          system-reserved = "cpu=500m,memory=256Mi"
          feature-gates = "SCTPSupport=True"
        }
      }
      kube_controller {
        cluster_cidr = var.rke_config.k8s_pod_range
        service_cluster_ip_range = var.rke_config.k8s_cluster_ip_range
        extra_args = {
          feature-gates = "SCTPSupport=True"
        }
      }
      scheduler {
        extra_args = {
          feature-gates = "SCTPSupport=True"
        }
      }
      kubeproxy {
        extra_args = {
          feature-gates = "SCTPSupport=True"
        }
      }
    }
    addons_include = ["https://raw.githubusercontent.com/hyunsun/terraform-rancher/master/modules/rancher/rke/multus-daemonset-pre-1.16.yml"]
  }
}

resource "null_resource" "nodes" {
  triggers = {
    cluster_nodes = length(var.nodes)
  }
  
  for_each = var.nodes  

  connection {
    type = "ssh"
    user = each.value.user
    host = each.value.host
    password = "cord"
  }

  provisioner "remote-exec" {
    inline = [
      "${rancher2_cluster.cluster.cluster_registration_token[0].node_command} ${each.value.roles}"
    ]
  }
}
