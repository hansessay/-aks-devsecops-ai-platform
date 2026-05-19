variable "enable_key_vault" {
  description = "Whether to manage Key Vault resources."
  type        = bool
}

variable "name_prefix" {
  description = "Key Vault name prefix before the random suffix."
  type        = string
}

variable "location" {
  description = "Azure region for Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "current_object_id" {
  description = "Object ID that receives Key Vault access policy permissions."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU."
  type        = string
}

variable "postgres_username" {
  description = "PostgreSQL username stored in Key Vault."
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL password stored in Key Vault."
  type        = string
  sensitive   = true
}

variable "postgres_database" {
  description = "PostgreSQL database stored in Key Vault."
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to Key Vault."
  type        = map(string)
}
