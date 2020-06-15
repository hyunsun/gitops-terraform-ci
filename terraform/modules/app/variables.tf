variable "project_id" {
  description = "Project ID that the application belong to."
  type        = string
}

variable "name" {
 description = "Name of the application."
 type        = string
}

variable "catalog_name" {
  description = "Catalog name of the application."
  type        = string
}

variable "template_name" {
 description = "Template name of the application." 
 type        = string
}

variable "template_version" {
 description = "Template version of the application." 
 type        = string
 default     = "latest"
}

variable "target_namespace" {
  description = "The namespace name where the app will be installed."
  type        = string
}

variable "values_yaml" {
 description = "Base64 encoded overriding values." 
 type        = string
}
