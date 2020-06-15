variable "username" {
 type        = string
 description = "Name of the user." 
}

variable "password" {
 type        = string
 description = "Password of the user." 
 default     = "changeme"
}

variable "global_role" {
 type        = string 
 description = "Global role name of the user."
 default     = "standard-user"
}

