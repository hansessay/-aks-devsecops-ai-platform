################################################################################
# STAGING ENVIRONMENT CONFIGURATION
# High-availability setup for pre-production testing
################################################################################

# =====================================
# Project & Location
# =====================================
project_name = "aks-enterprise-platform"
location     = "eastus"

# =====================================
# Network Configuration
# =====================================
address_space   = ["10.1.0.0/16"]
subnet_prefix   = ["10.1.0.0/22", "10.1.4.0/22"]

# =====================================
# AKS Cluster Configuration
# =====================================
node_count = 3                    # Higher than dev for HA
vm_size    = "Standard_D4s_v3"    # Medium sized nodes

# =====================================
# Networking - CNI Overlay
# =====================================
pod_cidr       = "10.244.0.0/16"
service_cidr   = "10.0.0.0/16"
dns_service_ip = "10.0.0.10"

# =====================================
# ArgoCD & Bootstrap Configuration
# =====================================
enable_argocd              = true
enable_root_app            = true
enable_external_secrets    = true

argocd_namespace        = "argocd"
argocd_service_type     = "LoadBalancer"
argocd_chart_version    = "7.3.4"
argocd_insecure_mode    = false

# =====================================
# GitOps Configuration
# =====================================
gitops_repo_url      = "https://github.com/hansessay/gitops-configs"
gitops_repo_revision = "stage"  # Track stage branch
platform_app_path    = "platform"
apps_app_path        = "apps"

# =====================================
# Alerting
# =====================================
oncall_email = "oncall-stage@example.com"

# =====================================
# CDN / Edge Configuration (disabled)
# =====================================
edge_origin_host_name   = "stage.chefall.duckdns.org"
edge_custom_domain_host_name = "stage.cheikhibra.duckdns.org"
