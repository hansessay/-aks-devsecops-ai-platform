resource "azurerm_kubernetes_cluster" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  node_resource_group = var.node_resource_group

  kubernetes_version = "1.33.10"

  default_node_pool {
    name            = "default"
    vm_size         = var.vm_size
    os_disk_size_gb = 30

    auto_scaling_enabled = true
    min_count            = 1
    max_count            = 5

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
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

resource "time_sleep" "wait_for_cluster" {
  depends_on = [
    azurerm_kubernetes_cluster.main
  ]

  create_duration = "60s"
}
