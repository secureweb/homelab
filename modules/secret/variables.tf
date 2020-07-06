variable "vault_helm_version" {
  type = string
}

variable "base_domain" {
  type = string
}

variable "oidc_discovery_url" {
  type = string
}

variable "oidc_client_id" {
  type = string
}

variable "oidc_client_secret" {
  type = string
}

variable "vault_redirect_uris" {
  type = list
}
