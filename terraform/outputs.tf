output "resource_group_name" {
  description = "Name of the resource group."
  value       = module.resource_group.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster."
  value       = module.aks.name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster."
  value       = module.aks.id
}

output "key_vault_name" {
  description = "Name of the Key Vault, when enabled."
  value       = module.keyvault.name
}
