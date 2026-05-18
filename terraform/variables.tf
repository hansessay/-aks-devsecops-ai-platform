variable "environment" {
  description = "Environment name, such as dev, staging, or prod."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources."
  type        = string
  default     = "sweden central"
}

variable "resource_group_name" {
  description = "Base name of the resource group."
  type        = string
  default     = "aks-gitops-rg"
}

variable "kubernetes_cluster_name" {
  description = "Base name of the AKS cluster."
  type        = string
  default     = "aks-gitops-cluster"
}

variable "vm_size" {
  description = "Size of the AKS node pool virtual machines."
  type        = string
  default     = "Standard_DC2s_v3"
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS."
  type        = string
  default     = "1.31.13"
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "AKS-GitOps"
    ManagedBy   = "Terraform"
  }
}

variable "enable_key_vault" {
  description = "Enable Key Vault for secrets management."
  type        = bool
  default     = true
}

variable "key_vault_sku" {
  description = "Key Vault SKU."
  type        = string
  default     = "standard"
}

variable "postgres_username" {
  description = "PostgreSQL admin username."
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL admin password."
  type        = string
  sensitive   = true
  default     = "SecurePassword123!"
}

variable "postgres_database" {
  description = "PostgreSQL database name."
  type        = string
  default     = "goalsdb"
}
