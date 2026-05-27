variable "aks_cluster_id" {
  description = "AKS cluster ID."
  type        = string
}

variable "aks_principal_id" {
  description = "AKS managed identity principal ID."
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID."
  type        = string
}

variable "current_principal_id" {
  description = "Current Azure principal object ID."
  type        = string
}
