resource "kubernetes_namespace" "namespace" {
  metadata {
    name = local.service_name
  }
}

resource "helm_release" "release" {
  name       = local.service_name
  repository = "https://hbahadorzadeh.github.io/helm-chart/"
  chart      = "matrix"
  namespace  = kubernetes_namespace.namespace.metadata.0.name

  values = [local.helm_chart_values]

}

locals {
  template_vars = {
    base_domain  = var.base_domain
    service_name = local.service_name
  }

  helm_chart_values = templatefile(
    "${path.module}/values.yaml.tpl",
    local.template_vars
  )
}
