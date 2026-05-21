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

  address_space           = var.address_space
  subnet_prefixes         = var.subnet_prefix
  ddos_protection_plan_id = module.edge.ddos_protection_plan_id
}

############################################
# EDGE: Front Door + CDN + WAF + DDoS + Workers
############################################
module "edge" {
  source = "../../modules/edge"

  name                = "edge-${var.project_name}-dev"
  location            = var.location
  resource_group_name = module.resource_group.name
  environment         = "dev"

  origin_host_name        = var.edge_origin_host_name
  origin_host_header      = var.edge_origin_host_header
  custom_domain_host_name = var.edge_custom_domain_host_name
  origin_http_port        = 80
  origin_https_port       = 443

  sku_name = "Premium_AzureFrontDoor"
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