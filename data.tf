############################################
# RESOURCE GROUP
############################################

data "azurerm_resource_group" "main" {
  name = "rg-aks-enterprise-platform-dev"
}

############################################
# CURRENT AZURE ACCOUNT INFORMATION
############################################

data "azurerm_client_config" "current" {}