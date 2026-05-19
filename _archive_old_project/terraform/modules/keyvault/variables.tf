variable "enabled" {
  description = "Whether to create Key Vault resources."
  type        = bool
}

variable "name_prefix" {
  description = "Prefix for the Key Vault name."
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

variable "tenant_id" {
  description = "Azure tenant ID."
  type        = string
}

variable "current_object_id" {
  description = "Current Azure principal object ID."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU."
  type        = string
}

variable "postgres_username" {
  description = "PostgreSQL admin username."
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL admin password. If empty, a random password is generated."
  type        = string
  sensitive   = true
}

variable "postgres_database" {
  description = "PostgreSQL database name."
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to Key Vault resources."
  type        = map(string)
}
