############################################
# MONITORING NAMESPACE
############################################
resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

############################################
# PROMETHEUS + GRAFANA
############################################
resource "helm_release" "kube_prometheus_stack" {
  name      = "kube-prometheus-stack"
  namespace = kubernetes_namespace_v1.monitoring.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  create_namespace = false

  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
}