locals {
  template_vars = {
  }

  helm_chart_values = templatefile(
    "${path.module}/values.yaml.tpl",
    local.template_vars
  )
}


resource "helm_release" "nginx" {
  atomic     = true
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = data.kubernetes_namespace.ingress.metadata.0.name

  values = [local.helm_chart_values]
}
