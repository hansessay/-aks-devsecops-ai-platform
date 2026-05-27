output "resource_group_name" {
  description = "Name of the AKS resource group."
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
  description = "Name of the Key Vault."
  value       = module.keyvault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault."
  value       = module.keyvault.vault_uri
}

output "cluster_identity_principal_id" {
  description = "Principal ID of the AKS system-assigned identity."
  value       = module.aks.principal_id
}

output "environment" {
  description = "Environment name."
  value       = var.environment
}

output "key_vault_id" {
  description = "ID of the Key Vault."
  value       = module.keyvault.id
}

output "kube_config" {
  description = "Raw kube config for the AKS cluster."
  value       = module.aks.kube_config
  sensitive   = true
}

output "kubelet_identity_client_id" {
  description = "Client ID of the AKS kubelet identity."
  value       = module.aks.kubelet_identity_client_id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet identity."
  value       = module.aks.kubelet_identity_object_id
}

output "postgres_connection_string_secret_name" {
  description = "Name of the postgres connection string secret."
  value       = module.keyvault.postgres_connection_string_secret_name
}

output "postgres_database_secret_name" {
  description = "Name of the postgres database secret."
  value       = module.keyvault.postgres_database_secret_name
}

output "postgres_password_secret_name" {
  description = "Name of the postgres password secret."
  value       = module.keyvault.postgres_password_secret_name
}

output "postgres_username_secret_name" {
  description = "Name of the postgres username secret."
  value       = module.keyvault.postgres_username_secret_name
}

output "tenant_id" {
  description = "Azure tenant ID."
  value       = data.azurerm_client_config.current.tenant_id
}
