terraform {
  backend "gcs" {
    bucket  = "aether-terraform-bucket"
    prefix  = "demo/state"
  }
}
