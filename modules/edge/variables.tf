variable "name" {
  description = "Prefix name for edge resources."
  type        = string
}

variable "location" {
  description = "Azure region for edge resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for edge resources."
  type        = string
}

variable "environment" {
  description = "Environment tag for edge resources."
  type        = string
  default     = "dev"
}

variable "origin_host_name" {
  description = "Host name for the Front Door origin."
  type        = string
}

variable "origin_host_header" {
  description = "Origin host header to send to the backend."
  type        = string
  default     = null
}

variable "custom_domain_host_name" {
  description = "Custom domain name to bind to Front Door."
  type        = string
  default     = null
}

variable "origin_http_port" {
  description = "HTTP port for the origin."
  type        = number
  default     = 80
}

variable "origin_https_port" {
  description = "HTTPS port for the origin."
  type        = number
  default     = 443
}

variable "origin_health_probe_path" {
  description = "Health probe path used for the origin group."
  type        = string
  default     = "/"
}

variable "origin_health_probe_protocol" {
  description = "Health probe protocol for the origin group."
  type        = string
  default     = "Http"
}

variable "forwarding_protocol" {
  description = "Forwarding protocol for the Front Door route."
  type        = string
  default     = "HttpsOnly"
}

variable "sku_name" {
  description = "SKU for the Front Door profile and firewall policy."
  type        = string
  default     = "Premium_AzureFrontDoor"
}
