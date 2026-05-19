variable "enable_key_vault" {
  description = "Whether External Secrets should be configured from Key Vault."
  type        = bool
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace for ArgoCD."
  type        = string
}

variable "gitops_repo_url" {
  description = "GitOps repository URL."
  type        = string
}

variable "app_repo_url" {
  description = "Application repository URL for ArgoCD."
  type        = string
}

variable "app_repo_path" {
  description = "Application path in the repository."
  type        = string
}

variable "resource_group_name" {
  description = "AKS resource group name."
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name."
  type        = string
}

variable "cluster_id" {
  description = "AKS cluster ID."
  type        = string
}

variable "kubelet_identity_client_id" {
  description = "AKS kubelet identity client ID."
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID."
  type        = string
}

variable "key_vault_uri" {
  description = "Key Vault URI."
  type        = string
}

variable "postgres_username_secret_id" {
  description = "Postgres username Key Vault secret ID."
  type        = string
}

variable "postgres_password_secret_id" {
  description = "Postgres password Key Vault secret ID."
  type        = string
}

variable "postgres_database_secret_id" {
  description = "Postgres database Key Vault secret ID."
  type        = string
}

variable "postgres_connection_secret_id" {
  description = "Postgres connection string Key Vault secret ID."
  type        = string
}

variable "postgres_username_secret_name" {
  description = "Postgres username Key Vault secret name."
  type        = string
}

variable "postgres_password_secret_name" {
  description = "Postgres password Key Vault secret name."
  type        = string
}

variable "postgres_database_secret_name" {
  description = "Postgres database Key Vault secret name."
  type        = string
}

variable "postgres_connection_secret_name" {
  description = "Postgres connection string Key Vault secret name."
  type        = string
}

variable "scripts_path" {
  description = "Absolute path to deployment scripts."
  type        = string
}

variable "manifests_path" {
  description = "Absolute path to Kubernetes manifests."
  type        = string
}

variable "root_path" {
  description = "Root path for local-exec working directory."
  type        = string
}

variable "argocd_status" {
  description = "ArgoCD Helm release status."
  type        = string
}
