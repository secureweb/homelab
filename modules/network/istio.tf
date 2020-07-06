module "istio-git" {
  source = "git::https://github.com/istio/istio.git//manifests/charts/istio-operator?depth=1"
}

resource "helm_release" "istio-operator" {
  name  = "istio-operator"
  chart = "${path.root}/.terraform/modules/network.istio-git/manifests/charts/istio-operator"

  set {
    name  = "hub"
    value = "docker.io/istio"
  }

  set {
    name  = "tag"
    value = "1.6.1"
  }

  set {
    name  = "operatorNamespace"
    value = "istio-operator"
  }

  set {
    name  = "istioNamespace"
    value = "istio-system"
  }
}

resource "kubernetes_manifest" "istio-operator" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "install.istio.io/v1alpha1"
    "kind"       = "IstioOperator"
    "metadata" = {
      "name"      = "default-istiocontrolplane"
      "namespace" = "istio-system"
    }
    "spec" = {
      "profile" = "default"
      "addonComponents" = {
        "grafana" = {
          "enabled" = true
        }
      }
      "components" = {
        "cni" = {
          "enabled" = true
        }
      }
      "values" = {
        "cni" = {
          "excludeNamespaces" = ["istio-system", "kube-system"]
          "logLevel"          = "info"
        }
      }
    }
  }
}
