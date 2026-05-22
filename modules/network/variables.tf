variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "address_space" {}
variable "subnet_prefixes" {}
variable "ddos_protection_plan_id" {
  description = "Optional DDoS protection plan ID to associate with the VNet."
  type        = string
  default     = null
}