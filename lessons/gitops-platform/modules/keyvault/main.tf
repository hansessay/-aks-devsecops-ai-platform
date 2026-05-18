resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "random_password" "postgres_password" {
  count   = var.enable_key_vault ? 1 : 0
  length  = 16
  special = true
}

resource "azurerm_key_vault" "main" {
  count               = var.enable_key_vault ? 1 : 0
  name                = "${var.name_prefix}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.current_object_id

    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  tags = var.common_tags
}

resource "azurerm_key_vault_secret" "postgres_username" {
  count        = var.enable_key_vault ? 1 : 0
  name         = "postgres-username"
  value        = var.postgres_username
  key_vault_id = azurerm_key_vault.main[0].id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  count        = var.enable_key_vault ? 1 : 0
  name         = "postgres-password"
  value        = var.postgres_password != "" ? var.postgres_password : random_password.postgres_password[0].result
  key_vault_id = azurerm_key_vault.main[0].id
}

resource "azurerm_key_vault_secret" "postgres_database" {
  count        = var.enable_key_vault ? 1 : 0
  name         = "postgres-database"
  value        = var.postgres_database
  key_vault_id = azurerm_key_vault.main[0].id
}

resource "azurerm_key_vault_secret" "postgres_connection_string" {
  count        = var.enable_key_vault ? 1 : 0
  name         = "postgres-connection-string"
  value        = "postgresql://${var.postgres_username}:${var.postgres_password != "" ? var.postgres_password : random_password.postgres_password[0].result}@postgres:5432/${var.postgres_database}"
  key_vault_id = azurerm_key_vault.main[0].id
}
