data "kubernetes_namespace" "ingress" {
  metadata {
    name = "kube-ingress"
  }
}
