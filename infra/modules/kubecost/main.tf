resource "kubernetes_namespace" "kubecost" {
  count = var.enabled ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kubecost" {
  count = var.enabled ? 1 : 0

  name       = "kubecost"
  repository = "https://kubecost.github.io/cost-analyzer/"
  chart      = "cost-analyzer"
  namespace  = kubernetes_namespace.kubecost[0].metadata[0].name

  wait = true

  depends_on = [kubernetes_namespace.kubecost]
}
