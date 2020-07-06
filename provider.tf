provider "kubernetes" {
  config_context_auth_info = "kubernetes-admin"
  config_context_cluster   = "kubernetes"
}

provider "kubernetes-alpha" {}

provider "vault" {
  address = "https://vault${var.base_domain}"
  token   = var.vault_token
}

provider "concourse" {
  target = "homelab"
}

provider "azuread" {
  tenant_id       = var.azure_tenant
  subscription_id = var.azure_tenant
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}
