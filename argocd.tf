############################################
# ARGOCD NAMESPACE
############################################
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

############################################
# ARGOCD HELM RELEASE
############################################
resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = kubernetes_namespace.argocd.metadata[0].name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  create_namespace = false

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.argocd
  ]
}