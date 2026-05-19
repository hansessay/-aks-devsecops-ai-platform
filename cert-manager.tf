############################################
# CERT-MANAGER NAMESPACE
############################################

resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

############################################
# CERT-MANAGER HELM INSTALL
############################################

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = kubernetes_namespace_v1.cert_manager.metadata[0].name

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.18.2"

  create_namespace = false

  set {
    name  = "crds.enabled"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace_v1.cert_manager
  ]
}