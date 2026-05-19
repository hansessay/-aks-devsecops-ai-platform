data "azurerm_container_registry" "acr" {
  name                = "chefallacr"
  resource_group_name = "rg-aks-enterprise-platform-dev"
}