################################################################################
# BOOTSTRAP MODULE OUTPUTS
# These outputs are used by scripts to automate platform validation/management
################################################################################

output "argocd_namespace" {
  description = "ArgoCD Kubernetes namespace"
  value       = var.enable_argocd ? kubernetes_namespace.argocd[0].metadata[0].name : null
}

output "argocd_service_name" {
  description = "ArgoCD service name"
  value       = var.enable_argocd ? helm_release.argocd[0].name : null
}

output "argocd_installed" {
  description = "Whether ArgoCD was installed by this module"
  value       = var.enable_argocd && helm_release.argocd[0].status == "deployed"
}

output "platform_app_name" {
  description = "Platform root ArgoCD application name"
  value       = var.enable_argocd && var.enable_root_app ? kubernetes_manifest.argocd_app_platform_root[0].manifest.metadata.name : null
}

output "apps_app_name" {
  description = "Apps root ArgoCD application name"
  value       = var.enable_argocd && var.enable_root_app ? kubernetes_manifest.argocd_app_apps_root[0].manifest.metadata.name : null
}

output "bootstrap_status_file" {
  description = "Path to bootstrap status file"
  value       = var.enable_argocd ? local_file.bootstrap_status[0].filename : null
}

output "kubeconfig_path" {
  description = "Kubeconfig file path"
  value       = local_file.kubeconfig_path.filename
}

output "gitops_repo_url" {
  description = "GitOps repository URL being used"
  value       = var.gitops_repo_url
}

output "gitops_repo_revision" {
  description = "GitOps repository revision (branch/tag)"
  value       = var.gitops_repo_revision
}
