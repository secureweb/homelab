resource "helm_release" "concourse" {
  name       = "concourse"
  repository = "https://concourse-charts.storage.googleapis.com/"
  chart      = "concourse"
  namespace  = "concourse"
  version    = var.concourse_helm_version

  set {
    name  = "web.ingress.enabled"
    value = true
  }

  set {
    name  = "web.ingress.hosts[0]"
    value = "concourse${var.base_domain}"
  }

  set {
    name  = "web.ingress.tls[0].hosts[0]"
    value = "concourse${var.base_domain}"
  }

  set {
    name  = "web.ingress.tls[0].secretName"
    value = "secureweb-tls"
  }

  set {
    name  = "concourse.web.externalUrl"
    value = "https://concourse${var.base_domain}"
  }

  set {
    name  = "concourse.web.kubernetes.keepNamespaces"
    value = false
  }

  set {
    name  = "concourse.web.localAuth.enabled"
    value = true
  }

  set {
    name  = "secrets.localUsers"
    value = "autoboarder:?Pwqq2r%Z!m#co<=d]urwQ7OHQ)NSQCY"
  }

  set {
    name  = "concourse.web.auth.oidc.enabled"
    value = true
  }

  set {
    name  = "concourse.web.auth.oidc.displayName"
    value = "Azure AD"
  }

  set {
    name  = "concourse.web.auth.oidc.issuer"
    value = var.oidc_discovery_url
  }

  set {
    name  = "secrets.oidcClientId"
    value = var.oidc_client_id
  }

  set {
    name  = "secrets.oidcClientSecret"
    value = var.oidc_client_secret
  }

  set {
    name  = "concourse.web.auth.oidc.userNameKey"
    value = "upn"
  }

  set {
    name  = "concourse.web.auth.oidc.groupsKey"
    value = "roles"
  }

  set {
    name  = "concourse.web.auth.mainTeam.oidc.group"
    value = "superusers"
  }

  set {
    name  = "concourse.web.kubernetes.enabled"
    value = "false"
  }

  set {
    name  = "concourse.web.vault.enabled"
    value = "true"
  }

  set {
    name  = "concourse.web.vault.url"
    value = "http://vault.vault.svc:8200"
  }

  set {
    name  = "concourse.web.vault.authBackend"
    value = "approle"
  }

}
