resource "azurerm_key_vault" "platform" {
  name                = "kv-cheikh-aks-dev"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  # New provider property
  rbac_authorization_enabled = true

  soft_delete_retention_days = 90

  tags = {
    environment = "dev"
    project     = "aks-enterprise-platform"
    managed_by  = "terraform"
  }
}