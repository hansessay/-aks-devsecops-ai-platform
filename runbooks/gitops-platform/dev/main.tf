data "azurerm_client_config" "current" {}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "AKS-GitOps"
  }

  infra_nodes_rg_name = "${var.kubernetes_cluster_name}-${var.environment}-nodes"
}

module "resource_group" {
  source = "../modules/resource-group"

  name        = "${var.resource_group_name}-${var.environment}"
  location    = var.location
  common_tags = local.common_tags
}

module "aks" {
  source = "../modules/aks"

  name                = "${var.kubernetes_cluster_name}-${var.environment}"
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_prefix          = "${var.kubernetes_cluster_name}-${var.environment}"
  node_resource_group = local.infra_nodes_rg_name
  vm_size             = var.vm_size
  common_tags         = local.common_tags
}

module "rbac" {
  source = "../modules/rbac"

  cluster_id           = module.aks.id
  resource_group_id    = module.resource_group.id
  current_principal_id = data.azurerm_client_config.current.object_id
  aks_principal_id     = module.aks.principal_id
}

module "keyvault" {
  source = "../modules/keyvault"

  enable_key_vault    = var.enable_key_vault
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

module "argocd" {
  source = "../modules/argocd"

  namespace   = var.argocd_namespace
  environment = var.environment

  depends_on = [module.aks]
}

module "kubecost" {
  source = "../modules/kubecost"

  enabled   = false
  namespace = "kubecost"

  depends_on = [module.aks]
}

module "app" {
  source = "../modules/app"

  enable_key_vault                = var.enable_key_vault
  environment                     = var.environment
  argocd_namespace                = var.argocd_namespace
  gitops_repo_url                 = var.gitops_repo_url
  app_repo_url                    = var.app_repo_url
  app_repo_path                   = var.app_repo_path
  resource_group_name             = module.resource_group.name
  cluster_name                    = module.aks.name
  cluster_id                      = module.aks.id
  kubelet_identity_client_id      = module.aks.kubelet_identity_client_id
  key_vault_id                    = module.keyvault.id
  key_vault_uri                   = module.keyvault.vault_uri
  postgres_username_secret_id     = module.keyvault.postgres_username_secret_id
  postgres_password_secret_id     = module.keyvault.postgres_password_secret_id
  postgres_database_secret_id     = module.keyvault.postgres_database_secret_id
  postgres_connection_secret_id   = module.keyvault.postgres_connection_string_secret_id
  postgres_username_secret_name   = module.keyvault.postgres_username_secret_name
  postgres_password_secret_name   = module.keyvault.postgres_password_secret_name
  postgres_database_secret_name   = module.keyvault.postgres_database_secret_name
  postgres_connection_secret_name = module.keyvault.postgres_connection_string_secret_name
  scripts_path                    = "${path.module}/scripts"
  manifests_path                  = "${path.module}/manifests"
  root_path                       = path.module
  argocd_status                   = module.argocd.status
  depends_on                      = [module.rbac, module.argocd]
}
