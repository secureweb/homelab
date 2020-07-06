locals {
  vault_redirect_uris     = ["http://localhost:8250/oidc/callback", "https://vault${var.base_domain}/ui/vault/auth/oidc/oidc/callback"]
  concourse_redirect_uris = ["https://concourse${var.base_domain}/sky/issuer/callback"]
  homelab_redirect_uris   = concat(local.concourse_redirect_uris, local.vault_redirect_uris)
}

module "azure" {
  source = "./modules/azure"

  base_domain           = var.base_domain
  additional_owners     = var.additional_owners
  homelab_redirect_uris = local.homelab_redirect_uris
}

module "cicd" {
  source = "./modules/cicd"

  concourse_helm_version = var.concourse_helm_version
  base_domain            = var.base_domain
  oidc_client_id         = module.azure.homelab_client_id
  oidc_client_secret     = module.azure.concourse_client_secret
  oidc_discovery_url     = "https://login.microsoftonline.com/${var.azure_tenant}/v2.0"
}

module "network" {
  source = "./modules/network"

  base_domain = var.base_domain
}

module "secret" {
  source = "./modules/secret"

  vault_helm_version  = var.vault_helm_version
  base_domain         = var.base_domain
  oidc_client_id      = module.azure.homelab_client_id
  oidc_client_secret  = module.azure.vault_client_secret
  oidc_discovery_url  = "https://login.microsoftonline.com/${var.azure_tenant}/v2.0"
  vault_redirect_uris = local.vault_redirect_uris
}

module "services" {
  source = "./modules/services"

  base_domain = var.base_domain
}
