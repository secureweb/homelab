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
      target_port = 5050
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
    replicas = 1

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
          image = "linuxserver/couchpotato"
          name  = "main"
          env {
            name = "TZ"
            value = "Europe/London"
          }
          env {
            name = "PUID"
            value = "1000"
          }
          env {
            name = "PGID"
            value = "1000"
          }
          volume_mount {
            name       = "${local.service_name}-config"
            mount_path = "/config"
          }
          volume_mount {
            name       = "${local.service_name}-media"
            mount_path = "/media"
          }
          volume_mount {
            name       = "${local.service_name}-downloads"
            mount_path = "/downloads"
          }
        }
        volume {
          name = "${local.service_name}-media"
          nfs {
            path   = "/data/news/media"
            server = "192.168.1.1"
          }
        }
        volume {
          name = "${local.service_name}-downloads"
          nfs {
            path   = "/data/news/downloads"
            server = "192.168.1.1"
          }
        }
        volume {
          name = "${local.service_name}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.config.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "config" {
  metadata {
    name = "config"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
  }
}


