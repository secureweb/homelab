resource "kubernetes_manifest" "istio-grafana-virtualservice" {
  provider = kubernetes-alpha
  manifest = {
    "kind" = "VirtualService"
    "metadata" = {
      "name"      = "emby"
      "namespace" = "istio-system"
    }
    "apiVersion" = "networking.istio.io/v1beta1"
    "spec" = {
      "gateways" = [
        "catchall",
      ]
      "hosts" = [
        "emby${var.base_domain}",
      ]
      "http" = [
        {
          "route" = [
            {
              "destination" = {
                "host" = "emby-embyserver.news.svc.cluster.local"
                "port" = {
                  "number" = 8096
                }
              }
            },
          ]
        },
      ]
    }
  }
}
