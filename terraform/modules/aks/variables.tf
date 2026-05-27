variable "name" {
  description = "AKS cluster name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "dns_prefix" {
  description = "AKS DNS prefix."
  type        = string
}

variable "node_resource_group" {
  description = "AKS managed node resource group name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version."
  type        = string
}

variable "vm_size" {
  description = "Default node pool VM size."
  type        = string
}

variable "min_count" {
  description = "Minimum node count for autoscaling."
  type        = number
}

variable "max_count" {
  description = "Maximum node count for autoscaling."
  type        = number
}

variable "common_tags" {
  description = "Tags to apply to the AKS cluster."
  type        = map(string)
}
