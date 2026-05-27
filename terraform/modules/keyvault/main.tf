resource "random_string" "suffix" {
  count   = var.enabled ? 1 : 0
  length  = 8
  special = false
  upper   = false
  numeric = true
}

resource "random_password" "postgres_password" {
  count   = var.enabled && var.postgres_password == "" ? 1 : 0
  length  = 16
  special = true
}

resource "azurerm_key_vault" "this" {
  count               = var.enabled ? 1 : 0
  name                = "${var.name_prefix}-${random_string.suffix[0].result}"
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
  count        = var.enabled ? 1 : 0
  name         = "postgres-username"
  value        = var.postgres_username
  key_vault_id = azurerm_key_vault.this[0].id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  count        = var.enabled ? 1 : 0
  name         = "postgres-password"
  value        = local.postgres_password
  key_vault_id = azurerm_key_vault.this[0].id
}

resource "azurerm_key_vault_secret" "postgres_database" {
  count        = var.enabled ? 1 : 0
  name         = "postgres-database"
  value        = var.postgres_database
  key_vault_id = azurerm_key_vault.this[0].id
}

resource "azurerm_key_vault_secret" "postgres_connection_string" {
  count        = var.enabled ? 1 : 0
  name         = "postgres-connection-string"
  value        = "postgresql://${var.postgres_username}:${local.postgres_password}@postgres:5432/${var.postgres_database}"
  key_vault_id = azurerm_key_vault.this[0].id
}

locals {
  postgres_password = var.postgres_password != "" ? var.postgres_password : random_password.postgres_password[0].result
}
