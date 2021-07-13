resource "kubernetes_namespace" "namespace" {
  metadata {
    name = local.service_name
  }
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name      = local.service_name
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    rule {
      host = "${local.service_name}.${var.base_domain}"
      http {
        path {
          backend {
            service_name = local.service_name
            service_port = 80
          }
          path = "/"
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name      = local.service_name
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    selector = {
      app = local.service_name
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
  }
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = local.service_name
    namespace = kubernetes_namespace.namespace.metadata.0.name
    labels = {
      app = local.service_name
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = local.service_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.service_name
        }
      }

      spec {
        container {
          image = "httpd"
          name  = "website"
          volume_mount {
            name       = local.service_name
            mount_path = "/usr/local/apache2/htdocs"
          }
        }
        volume {
          name = local.service_name
          nfs {
            path   = "/data/public"
            server = "192.168.1.1"
          }
        }
      }
    }
  }
}
