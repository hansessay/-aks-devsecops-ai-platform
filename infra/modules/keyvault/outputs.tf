output "id" {
  description = "ID of the Key Vault."
  value       = try(azurerm_key_vault.main[0].id, null)
}

output "name" {
  description = "Name of the Key Vault."
  value       = try(azurerm_key_vault.main[0].name, null)
}

output "vault_uri" {
  description = "URI of the Key Vault."
  value       = try(azurerm_key_vault.main[0].vault_uri, null)
}

output "postgres_username_secret_id" {
  description = "ID of the postgres username secret."
  value       = try(azurerm_key_vault_secret.postgres_username[0].id, null)
}

output "postgres_password_secret_id" {
  description = "ID of the postgres password secret."
  value       = try(azurerm_key_vault_secret.postgres_password[0].id, null)
}

output "postgres_database_secret_id" {
  description = "ID of the postgres database secret."
  value       = try(azurerm_key_vault_secret.postgres_database[0].id, null)
}

output "postgres_connection_string_secret_id" {
  description = "ID of the postgres connection string secret."
  value       = try(azurerm_key_vault_secret.postgres_connection_string[0].id, null)
}

output "postgres_username_secret_name" {
  description = "Name of the postgres username secret."
  value       = "postgres-username"
}

output "postgres_password_secret_name" {
  description = "Name of the postgres password secret."
  value       = "postgres-password"
}

output "postgres_database_secret_name" {
  description = "Name of the postgres database secret."
  value       = "postgres-database"
}

output "postgres_connection_string_secret_name" {
  description = "Name of the postgres connection string secret."
  value       = "postgres-connection-string"
}
