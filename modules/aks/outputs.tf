output "name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0]
  sensitive = true
}

output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}