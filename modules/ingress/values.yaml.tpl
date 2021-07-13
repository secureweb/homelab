---
controller:
  hostNetwork: true
  dnsPolicy: ClusterFirstWithHostNet
  extraArgs: 
    default-ssl-certificate: "kube-ingress/secureweb-tls"
  config:
    force-ssl-redirect: "true"
  kind: DaemonSet
  service:
    type: ClusterIP

defaultBackend:
  enabled: true
