variable "cluster_id" {
  description = "AKS cluster scope for admin role assignment."
  type        = string
}

variable "resource_group_id" {
  description = "Resource group scope for AKS role assignments."
  type        = string
}

variable "current_principal_id" {
  description = "Object ID of the current Terraform principal."
  type        = string
}

variable "aks_principal_id" {
  description = "Principal ID of the AKS system-assigned identity."
  type        = string
}
