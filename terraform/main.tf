data "azurerm_client_config" "current" {}

locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = "AKS-GitOps"
    }
  )
}

module "resource_group" {
  source = "./modules/resource_group"

  name        = "${var.resource_group_name}-${var.environment}"
  location    = var.location
  common_tags = local.common_tags
}

module "aks" {
  source = "./modules/aks"

  name                = "${var.kubernetes_cluster_name}-${var.environment}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  node_resource_group = "${var.kubernetes_cluster_name}-${var.environment}-nodes"
  dns_prefix          = "${var.kubernetes_cluster_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  vm_size             = var.vm_size
  min_count           = 1
  max_count           = 5
  common_tags         = local.common_tags
}

module "rbac" {
  source = "./modules/rbac"

  aks_cluster_id       = module.aks.id
  aks_principal_id     = module.aks.principal_id
  resource_group_id    = module.resource_group.id
  current_principal_id = data.azurerm_client_config.current.object_id
}

module "keyvault" {
  source = "./modules/keyvault"

  enabled             = var.enable_key_vault
  name_prefix         = "kv-${var.environment}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  current_object_id   = data.azurerm_client_config.current.object_id
  sku_name            = var.key_vault_sku
  postgres_username   = var.postgres_username
  postgres_password   = var.postgres_password
  postgres_database   = var.postgres_database
  common_tags         = local.common_tags
}
