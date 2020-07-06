resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = "https://192.168.1.5:6443"
  kubernetes_ca_cert = base64decode(trimspace(local.ca_split[1]))
  token_reviewer_jwt = data.kubernetes_secret.vault.data.token
  #  issuer             = "api"
}

data "kubernetes_service_account" "vault_sa" {
  metadata {
    name      = "vault"
    namespace = "vault"
  }
}

data "kubernetes_secret" "vault" {
  metadata {
    name      = "${data.kubernetes_service_account.vault_sa.default_secret_name}"
    namespace = "vault"
  }
}

data "kubernetes_config_map" "ca" {
  metadata {
    name      = "cluster-info"
    namespace = "kube-public"
  }
}

locals {
  ca_k8s   = split("\n", data.kubernetes_config_map.ca.data.kubeconfig)
  ca_split = split(":", local.ca_k8s[3])
}

resource "vault_kubernetes_auth_backend_role" "super_user" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "superuser"
  bound_service_account_names      = ["default"]
  bound_service_account_namespaces = ["default"]
  token_ttl                        = 3600
  token_policies                   = ["default", "superuser"]
  #  audience                         = "vault"

}
