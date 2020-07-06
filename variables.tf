variable "base_domain" {
  type = string
}

variable "concourse_helm_version" {
  type = string
}

variable "vault_helm_version" {
  type = string
}

variable "azure_tenant" {
  type = string
}

variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "additional_owners" {
  type    = list
  default = []
}

variable "vault_token" {
  type = string
}
