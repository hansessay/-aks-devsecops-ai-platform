################################################################################
# PRODUCTION ENVIRONMENT CONFIGURATION
# Enterprise-grade setup with high availability and security
################################################################################

# =====================================
# Project & Location
# =====================================
project_name = "aks-enterprise-platform"
location     = "eastus"  # Primary region

# =====================================
# Network Configuration
# =====================================
address_space   = ["10.2.0.0/16"]
subnet_prefix   = ["10.2.0.0/22", "10.2.4.0/22"]

# =====================================
# AKS Cluster Configuration
# =====================================
node_count = 5                    # High availability
vm_size    = "Standard_D8s_v3"    # Large nodes for production workloads

# =====================================
# Networking - CNI Overlay
# =====================================
pod_cidr       = "10.245.0.0/16"
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
argocd_insecure_mode    = false  # Enforce HTTPS in production

# =====================================
# GitOps Configuration
# =====================================
gitops_repo_url      = "https://github.com/hansessay/gitops-configs"
gitops_repo_revision = "main"  # Production uses main branch with reviews
platform_app_path    = "platform"
apps_app_path        = "apps"

# =====================================
# Alerting
# =====================================
oncall_email = "oncall@example.com"

# =====================================
# CDN / Edge Configuration (disabled)
# =====================================
edge_origin_host_name   = "prod.chefall.duckdns.org"
edge_custom_domain_host_name = "prod.cheikhibra.duckdns.org"
