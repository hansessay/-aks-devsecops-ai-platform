############################################
# RESOURCE GROUP
############################################
module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-${var.project_name}-dev"
  location = var.location
}

############################################
# NETWORK
############################################
module "network" {
  source = "../../modules/network"

  name                = "vnet-${var.project_name}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name

  address_space   = var.address_space
  subnet_prefixes = var.subnet_prefix
}

############################################
# AKS CLUSTER (AZURE CNI OVERLAY)
############################################
module "aks" {
  source = "../../modules/aks"

  name                = "aks-${var.project_name}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name
  dns_prefix          = "aks-${var.project_name}-dev"

  node_count = var.node_count
  vm_size    = var.vm_size
  subnet_id  = module.network.aks_subnet_id

  pod_cidr       = var.pod_cidr
  service_cidr   = var.service_cidr
  dns_service_ip = var.dns_service_ip
}