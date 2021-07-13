resource "kubernetes_secret" "cloudflare_api" {
  metadata {
    name      = "cloudflare-secret"
    namespace = data.kubernetes_namespace.ingress.metadata.0.name
  }
  data = {
    "api-token" = var.cloudflare_api_token
  }
}

resource "kubernetes_manifest" "cert_issuer" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Issuer"
    "metadata" = {
      "name"      = "letsencrypt-prod"
      "namespace" = data.kubernetes_namespace.ingress.metadata.0.name
    }
    "spec" = {
      "acme" = {
        "email" = "letsencrypt@secureweb.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "dns01" = {
              "cloudflare" = {
                "apiTokenSecretRef" = {
                  "key"  = "api-token"
                  "name" = kubernetes_secret.cloudflare_api.metadata.0.name
                }
                "email" = "allan@secureweb.ltd"
              }
            }
          }
        ]
      }
    }
  }
}

resource "kubernetes_manifest" "cert_cert" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"
    "metadata" = {
      "name"      = "secureweb-tls"
      "namespace" = data.kubernetes_namespace.ingress.metadata.0.name
    }
    "spec" = {
      "dnsNames" = [
        var.base_domain,
        "*.${var.base_domain}"
      ]
      "issuerRef" = {
        "kind" = "Issuer"
        "name" = "letsencrypt-prod"
      }
      "secretName" = "secureweb-tls"
    }
  }
}
