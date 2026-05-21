variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
}

variable "subnet_prefix" {
  description = "Subnet address prefixes"
  type        = list(string)
}

variable "node_count" {
  description = "Number of AKS nodes"
  type        = number
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "pod_cidr" {
  description = "Pod CIDR for Azure CNI overlay"
  type        = string
}

variable "service_cidr" {
  description = "Service CIDR range"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS service IP must be inside service CIDR"
  type        = string
  default     = "10.0.0.10"
}

variable "edge_origin_host_name" {
  description = "Origin hostname for Azure Front Door and CDN."
  type        = string
  default     = "chefall.duckdns.org"
}

variable "edge_origin_host_header" {
  description = "Host header sent to the origin from Front Door."
  type        = string
  default     = null
}

variable "edge_custom_domain_host_name" {
  description = "The custom domain to bind to Front Door."
  type        = string
  default     = "cheikhibra.duckdns.org"
}

variable "oncall_email" {
  description = "Email address to notify for AKS alerting."
  type        = string
  default     = "oncall@example.com"
}

