resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  namespace  = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  create_namespace = true

  values = [
    <<EOF
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 100m
    memory: 128Mi
EOF
  ]
}