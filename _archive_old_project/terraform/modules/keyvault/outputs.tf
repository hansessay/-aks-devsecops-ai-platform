output "id" {
  description = "Key Vault ID, when enabled."
  value       = var.enabled ? azurerm_key_vault.this[0].id : null
}

output "name" {
  description = "Key Vault name, when enabled."
  value       = var.enabled ? azurerm_key_vault.this[0].name : null
}
