output "id" {
  description = "ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.id
}

output "name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.name
}

output "principal_id" {
  description = "Principal ID of the AKS system-assigned identity."
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

output "kube_config" {
  description = "Raw kube config for the AKS cluster."
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "kubelet_identity_client_id" {
  description = "Client ID of the AKS kubelet identity."
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet identity."
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "wait_for_cluster_id" {
  description = "ID of the cluster wait resource."
  value       = time_sleep.wait_for_cluster.id
}
