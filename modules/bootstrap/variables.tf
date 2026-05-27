################################################################################
# BOOTSTRAP MODULE VARIABLES
################################################################################

# =====================================
# AKS / Kubernetes Configuration
# =====================================
variable "kube_config_path" {
  description = "Path to kubeconfig file for kubectl access"
  type        = string
  default     = "~/.kube/config"
}

# =====================================
# ArgoCD Configuration
# =====================================
variable "enable_argocd" {
  description = "Enable ArgoCD installation and configuration"
  type        = bool
  default     = true
}

variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.3.4"
}

variable "argocd_service_type" {
  description = "ArgoCD service type (LoadBalancer, NodePort, ClusterIP)"
  type        = string
  default     = "LoadBalancer"

  validation {
    condition     = contains(["LoadBalancer", "NodePort", "ClusterIP"], var.argocd_service_type)
    error_message = "Service type must be LoadBalancer, NodePort, or ClusterIP."
  }
}

variable "argocd_insecure_mode" {
  description = "Enable insecure mode for ArgoCD (for dev/test only)"
  type        = bool
  default     = false
}

variable "argocd_url" {
  description = "ArgoCD server URL"
  type        = string
  default     = "http://localhost:8080"
}

variable "argocd_replicas" {
  description = "Number of ArgoCD replicas"
  type        = number
  default     = 1
}

variable "argocd_instances" {
  description = "ArgoCD instances limit for large deployments"
  type        = number
  default     = 0
}

# =====================================
# GitOps Repository Configuration
# =====================================
variable "gitops_repo_url" {
  description = "GitOps repository URL"
  type        = string
}

variable "gitops_repo_revision" {
  description = "GitOps repository branch/tag"
  type        = string
  default     = "main"
}

variable "gitops_repo_config" {
  description = "ArgoCD repository configuration for credential management"
  type = list(object({
    url  = string
    type = string
  }))
  default = []
}

variable "enable_root_app" {
  description = "Enable automatic deployment of root applications"
  type        = bool
  default     = true
}

variable "platform_app_path" {
  description = "Path to platform root app in GitOps repo"
  type        = string
  default     = "platform"
}

variable "apps_app_path" {
  description = "Path to apps root app in GitOps repo"
  type        = string
  default     = "apps"
}

# =====================================
# External Secrets Configuration
# =====================================
variable "enable_external_secrets" {
  description = "Enable external-secrets integration for Key Vault"
  type        = bool
  default     = false
}

variable "keyvault_uri" {
  description = "Azure Key Vault URI"
  type        = string
  default     = ""
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID for Key Vault integration"
  type        = string
  default     = ""
}

# =====================================
# Bootstrap Tagging
# =====================================
variable "tags" {
  description = "Common tags for all bootstrap resources"
  type        = map(string)
  default = {
    "managed_by"  = "terraform"
    "component"   = "bootstrap"
    "environment" = "dev"
  }
}
