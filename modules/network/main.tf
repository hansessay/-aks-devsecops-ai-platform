resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id == null ? [] : [var.ddos_protection_plan_id]

    content {
      id     = ddos_protection_plan.value
      enable = true
    }
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "snet-aks"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes
}