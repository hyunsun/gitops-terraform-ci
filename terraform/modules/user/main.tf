terraform {
  required_providers {
    rancher2 = {
      source  = "terraform-providers/rancher2"
      version = "<= 1.8.3"
    }
  }
}

resource "rancher2_user" "user" {
  name     = var.username
  username = var.username
  password = var.password
  enabled  = true
}

resource "rancher2_global_role_binding" "role_binding" {
  name           = var.username
  global_role_id = var.global_role
  user_id        = rancher2_user.user.id
}
