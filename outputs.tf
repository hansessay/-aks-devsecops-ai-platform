# =====================================
# Edge / Front Door outputs (disabled)
# Student / Free Trial limitation
# =====================================

# output "edge_frontdoor_endpoint_host_name" {
#   value = module.edge.frontdoor_endpoint_host_name
# }

# output "edge_custom_domain_host_name" {
#   value = module.edge.custom_domain_host_name
# }

# output "edge_custom_domain_validation_token" {
#   value = module.edge.custom_domain_validation_token
# }

# output "edge_custom_domain_cname_target" {
#   value = module.edge.custom_domain_cname_target
# }

# output "edge_ddos_protection_plan_id" {
#   value = module.edge.ddos_protection_plan_id
# }

# output "edge_frontdoor_route_id" {
#   value = module.edge.frontdoor_route_id
# }

# output "edge_waf_policy_id" {
#   value = module.edge.waf_policy_id
# }

# output "edge_worker_rule_set_id" {
#   value = module.edge.worker_rule_set_id
# }

################################################################################
# BOOTSTRAP & ARGOCD OUTPUTS
################################################################################

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.cluster_name
}

output "aks_resource_group" {
  description = "Resource group containing AKS cluster"
  value       = module.resource_group.name
}

output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = module.bootstrap.argocd_namespace
}

output "argocd_service_name" {
  description = "ArgoCD service name"
  value       = module.bootstrap.argocd_service_name
}

output "argocd_installed" {
  description = "Whether ArgoCD has been installed"
  value       = module.bootstrap.argocd_installed
}

output "platform_app_name" {
  description = "Platform root ArgoCD application name"
  value       = module.bootstrap.platform_app_name
}

output "apps_app_name" {
  description = "Apps root ArgoCD application name"
  value       = module.bootstrap.apps_app_name
}

output "gitops_repo_url" {
  description = "GitOps repository URL"
  value       = module.bootstrap.gitops_repo_url
}

output "gitops_repo_revision" {
  description = "GitOps repository revision (branch/tag)"
  value       = module.bootstrap.gitops_repo_revision
}

output "bootstrap_status_file" {
  description = "Path to bootstrap status file with next steps"
  value       = module.bootstrap.bootstrap_status_file
  sensitive   = false
}

output "keyvault_name" {
  description = "Key Vault name for secrets storage"
  value       = azurerm_key_vault.platform.name
}

output "keyvault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.platform.vault_uri
}

################################################################################
# BOOTSTRAP COMMANDS - Ready-to-use kubectl commands
################################################################################

output "bootstrap_commands" {
  description = "Ready-to-use commands for managing the platform"
  value = {
    get_argocd_password = "kubectl get secret argocd-initial-admin-secret -n ${module.bootstrap.argocd_namespace} -o jsonpath=\"{.data.password}\" | base64 -d"
    
    port_forward_argocd = "kubectl port-forward svc/${module.bootstrap.argocd_service_name} -n ${module.bootstrap.argocd_namespace} 8080:443"
    
    watch_platform_app = "kubectl get applications -n ${module.bootstrap.argocd_namespace} ${module.bootstrap.platform_app_name} -w"
    
    watch_apps_app = "kubectl get applications -n ${module.bootstrap.argocd_namespace} ${module.bootstrap.apps_app_name} -w"
    
    get_argocd_status = "kubectl get applications -n ${module.bootstrap.argocd_namespace}"
    
    get_argocd_logs = "kubectl logs -n ${module.bootstrap.argocd_namespace} -l app.kubernetes.io/name=argocd-server -f"
  }
}