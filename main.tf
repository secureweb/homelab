locals {
  vault_redirect_uris     = ["http://localhost:8250/oidc/callback", "https://vault.${var.base_domain}/ui/vault/auth/oidc/oidc/callback"]
  concourse_redirect_uris = ["https://concourse.${var.base_domain}/sky/issuer/callback"]
  gitlab_redirect_uris    = ["https://gitlab.${var.base_domain}/users/auth/azure_oauth2/callback"]
  homelab_redirect_uris   = concat(local.concourse_redirect_uris, local.vault_redirect_uris, local.gitlab_redirect_uris)
}

module "azure" {
  source = "./modules/azure"

  homelab_redirect_uris = local.homelab_redirect_uris
  additional_owners     = var.additional_owners
}

module "cilium" {
  source = "./modules/cilium"
}

module "cert-manager" {
  source = "./modules/cert-manager"
}

module "cloudflare" {
  source = "./modules/cloudflare"

  cloudflare_email     = var.cloudflare_email
  cloudflare_api_token = var.cloudflare_api_token
  cloudflare_zone_id   = var.cloudflare_zone_id
}

module "ingress" {
  depends_on = [module.cert-manager]
  source     = "./modules/ingress"

  base_domain         = var.base_domain
  cloudflare_api_token = var.cloudflare_api_token
}

module "downloads" {
  source = "./modules/downloads"
}

#module "matrix" {
#  source = "./modules/matrix"
#}

module "jellyfin" {
  source = "./modules/jellyfin"
}

module "sonarr" {
  source = "./modules/sonarr"
}

module "radarr" {
  source = "./modules/radarr"
}

module "sabnzbd" {
  source = "./modules/sabnzbd"
}

module "foodnow" {
  source = "./modules/foodnow"
}

module "network" {
  source = "./modules/network"

  base_domain         = var.base_domain
  cloudflare_api_token = var.cloudflare_api_token

  ingress = [
    {
      name      = "emby"
      service   = "emby-embyserver"
      namespace = "news"
      port      = 8096
    },
    {
      name      = "concourse"
      service   = "concourse-web"
      namespace = "concourse"
      port      = 8080
    },
    {
      name      = "sabnzbd"
      service   = "sabnzbd"
      namespace = "news"
      port      = 8080
    },
    {
      name      = "sonarr"
      service   = "sonarr"
      namespace = "news"
      port      = 8081
    },
    {
      name      = "couchpotato"
      service   = "couchpotato"
      namespace = "news"
      port      = 80
    },
    {
      name      = "hubble"
      service   = "hubble-ui"
      namespace = "kube-system"
      port      = 80
    },
    {
      name      = "gitlab"
      service   = "gitlab-webservice"
      namespace = "gitlab"
      port      = 8181
    },
    {
      name      = "grafana"
      service   = "grafana"
      namespace = "grafana"
      port      = 80
    },
    {
      name      = "vault"
      service   = "vault"
      namespace = "vault"
      port      = 8200
    },
  ]
}

module "loki" {
  source = "./modules/loki"
}

module "grafana" {
  source = "./modules/grafana"
  base_domain = var.base_domain
}

module "gitea" {
  source = "./modules/gitea"
}
