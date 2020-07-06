resource "helm_release" "cilium" {
  atomic     = true
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  namespace  = "kube-system"
  version    = "v1.7.4"

  set {
    name  = "global.containerRuntime.integration"
    value = "auto"
  }

  set {
    name  = "global.prometheus.enabled"
    value = true
  }

  set {
    name  = "global.kubeProxyReplacement"
    value = "strict"
  }

  set {
    name  = "global.k8sServiceHost"
    value = "192.168.1.5"
  }

  set {
    name  = "global.k8sServicePort"
    value = "6443"
  }

}
