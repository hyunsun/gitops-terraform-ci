terraform {
  backend "gcs" {
    bucket  = "aether-terraform-bucket"
    prefix  = "dev/state"
  }
}
