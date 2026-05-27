variable "name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to the resource group."
  type        = map(string)
}
