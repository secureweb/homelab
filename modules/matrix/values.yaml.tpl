---
matrix:
  serverName: ${base_domain}
  hostname: ${service_name}.${base_domain}
  adminEmail: ${service_name}@${base_domain}

ingress:
  enabled: true
  federation: true
  tls: 
  hosts:
    synapse: ${service_name}.${base_domain}
    riot: element.${base_domain}
    federation: ${service_name}-fed.${base_domain}
  annotations:
    # This annotation is required for the Nginx ingress provider. You can remove it if you use a different ingress provider
    nginx.ingress.kubernetes.io/configuration-snippet: |
      proxy_intercept_errors off;
