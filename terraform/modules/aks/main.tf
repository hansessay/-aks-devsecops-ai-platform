resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  node_resource_group = var.node_resource_group
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = "default"
    vm_size              = var.vm_size
    os_disk_size_gb      = 30
    auto_scaling_enabled = true
    min_count            = var.min_count
    max_count            = var.max_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = var.common_tags
}
