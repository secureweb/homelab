resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.service_name
  }
}


resource "helm_release" "main" {
  atomic     = true
  name       = "gitea"
  repository = "https://dl.gitea.io/charts/"
  chart      = "gitea"
  namespace  = kubernetes_namespace.namespace.metadata.0.name

  values = templatefile(
    "${path.module}/values.yaml.tpl"
  )  

}
