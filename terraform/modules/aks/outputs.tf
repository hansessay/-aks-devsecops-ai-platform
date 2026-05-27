output "id" {
  description = "AKS cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "AKS cluster name."
  value       = azurerm_kubernetes_cluster.this.name
}

output "principal_id" {
  description = "System-assigned managed identity principal ID."
  value       = azurerm_kubernetes_cluster.this.identity[0].principal_id
}
