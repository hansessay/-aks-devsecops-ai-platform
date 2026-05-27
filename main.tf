module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-${var.project_name}-dev"
  location = var.location
}

module "network" {
  source = "../../modules/network"

  name                = "vnet-${var.project_name}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name

  address_space   = var.address_space
  subnet_prefixes = var.subnet_prefix

  # Edge module disabled
  # Azure Front Door unavailable on Student/Free subscription
  # ddos_protection_plan_id = module.edge.ddos_protection_plan_id
}

module "aks" {
  source = "../../modules/aks"

  name                = "aks-${var.project_name}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name

  dns_prefix     = "aks-${var.project_name}-dev"
  node_count     = var.node_count
  vm_size        = var.vm_size
  subnet_id      = module.network.aks_subnet_id
  pod_cidr       = var.pod_cidr
  service_cidr   = var.service_cidr
  dns_service_ip = var.dns_service_ip
}

################################################################################
# BOOTSTRAP MODULE - Orchestrates ArgoCD and GitOps deployment
################################################################################
module "bootstrap" {
  source = "../../modules/bootstrap"

  # Enable bootstrap automation
  enable_argocd     = var.enable_argocd
  enable_root_app   = var.enable_root_app
  enable_external_secrets = var.enable_external_secrets

  # ArgoCD Configuration
  argocd_namespace        = var.argocd_namespace
  argocd_service_type     = var.argocd_service_type
  argocd_chart_version    = var.argocd_chart_version
  argocd_insecure_mode    = var.argocd_insecure_mode

  # GitOps Repository
  gitops_repo_url         = var.gitops_repo_url
  gitops_repo_revision    = var.gitops_repo_revision
  platform_app_path       = var.platform_app_path
  apps_app_path           = var.apps_app_path

  # Key Vault Integration
  keyvault_uri            = azurerm_key_vault.platform.vault_uri
  azure_tenant_id         = data.azurerm_client_config.current.tenant_id

  # Depends on AKS cluster
  depends_on = [
    module.aks,
    kubernetes_namespace.argocd
  ]
}