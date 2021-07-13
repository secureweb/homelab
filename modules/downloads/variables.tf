locals {
  service_name = var.hostname
}

variable "base_domain" {
  type    = string
  default = "secureweb.ltd"
}

variable "hostname" {
  type    = string
  default = "downloads"
}
