resource "vault_jwt_auth_backend" "azure" {
  description        = "Demonstration of the Terraform JWT auth backend"
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = var.oidc_discovery_url
  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  default_role       = "default"
}

resource "vault_jwt_auth_backend_role" "default" {
  backend        = vault_jwt_auth_backend.azure.path
  role_name      = "default"
  token_policies = ["default"]

  oidc_scopes           = ["https://graph.microsoft.com/.default"]
  user_claim            = "name"
  groups_claim          = "roles"
  role_type             = "oidc"
  allowed_redirect_uris = var.vault_redirect_uris
}

data "vault_policy_document" "super_user" {
  rule {
    path         = "*"
    capabilities = ["create", "read", "update", "delete", "list"]
    description  = "allow all on _everything_. Careful."
  }
}

resource "vault_policy" "super_user" {
  name   = "superuser"
  policy = data.vault_policy_document.super_user.hcl
}

resource "vault_identity_group" "super_user" {
  name              = "superusers"
  type              = "external"
  external_policies = true
}

resource "vault_identity_group_alias" "super_user" {
  name           = "superusers"
  mount_accessor = vault_jwt_auth_backend.azure.accessor
  canonical_id   = vault_identity_group.super_user.id
}

resource "vault_identity_group_policies" "super_user" {
  policies = [
    "default",
    vault_policy.super_user.name,
  ]
  exclusive = true
  group_id  = vault_identity_group.super_user.id
}

