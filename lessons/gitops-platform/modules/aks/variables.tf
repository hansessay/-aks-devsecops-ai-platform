variable "name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that contains the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster."
  type        = string
}

variable "node_resource_group" {
  description = "Node resource group name for AKS-managed infrastructure."
  type        = string
}

variable "vm_size" {
  description = "VM size for the default node pool."
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to AKS."
  type        = map(string)
}
