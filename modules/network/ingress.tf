resource "kubernetes_manifest" "istio-kubernetes-gateway" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "kubernetes"
      "namespace" = "default"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "kubernetes${var.base_domain}",
          ]
          "port" = {
            "name"     = "http"
            "number"   = 443
            "protocol" = "HTTPS"
          }
          "tls" = {
            "mode" = "PASSTHROUGH"
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "istio-catchall-gateway" {
  provider = kubernetes-alpha
  manifest = {
    "apiVersion" = "networking.istio.io/v1beta1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = "catchall"
      "namespace" = "istio-system"
    }
    "spec" = {
      "selector" = {
        "istio" = "ingressgateway"
      }
      "servers" = [
        {
          "hosts" = [
            "*${var.base_domain}",
          ]
          "port" = {
            "name"     = "https"
            "number"   = 443
            "protocol" = "HTTPS"
          }
          "tls" = {
            "mode"           = "SIMPLE"
            "credentialName" = "secureweb-tls"
          }
        },
        {
          "hosts" = [
            "*${var.base_domain}",
          ]
          "port" = {
            "name"     = "http"
            "number"   = 80
            "protocol" = "HTTP"
          }
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "istio-kubernetes-virtualservice" {
  provider = kubernetes-alpha
  manifest = {
    "kind" = "VirtualService"
    "metadata" = {
      "name"      = "kubernetes"
      "namespace" = "default"
    }
    "apiVersion" = "networking.istio.io/v1beta1"
    "spec" = {
      "gateways" = [
        "kubernetes",
      ]
      "hosts" = [
        "kubernetes${var.base_domain}",
      ]
      "tls" = [
        {
          "match" = [
            {
              "port" = 443
              "sniHosts" = [
                "kubernetes${var.base_domain}",
              ]
            },
          ]
          "route" = [
            {
              "destination" = {
                "host" = "kubernetes"
                "port" = {
                  "number" = 443
                }
              }
            },
          ]
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "istio-grafana-virtualservice" {
  provider = kubernetes-alpha
  manifest = {
    "kind" = "VirtualService"
    "metadata" = {
      "name"      = "grafana"
      "namespace" = "istio-system"
    }
    "apiVersion" = "networking.istio.io/v1beta1"
    "spec" = {
      "gateways" = [
        "catchall",
      ]
      "hosts" = [
        "grafana${var.base_domain}",
      ]
      "http" = [
        {
          "route" = [
            {
              "destination" = {
                "host" = "grafana"
                "port" = {
                  "number" = 3000
                }
              }
            },
          ]
        },
      ]
    }
  }
}

resource "kubernetes_manifest" "istio-prometheus-virtualservice" {
  provider = kubernetes-alpha
  manifest = {
    "kind" = "VirtualService"
    "metadata" = {
      "name"      = "prometheus"
      "namespace" = "istio-system"
    }
    "apiVersion" = "networking.istio.io/v1beta1"
    "spec" = {
      "gateways" = [
        "catchall",
      ]
      "hosts" = [
        "prometheus${var.base_domain}",
      ]
      "http" = [
        {
          "route" = [
            {
              "destination" = {
                "host" = "prometheus"
                "port" = {
                  "number" = 9090
                }
              }
            },
          ]
        },
      ]
    }
  }
}
