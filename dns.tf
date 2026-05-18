############################################
# DUCKDNS AUTOMATION
############################################

variable "duckdns_domain" {
  description = "DuckDNS domain name without .duckdns.org"
  type        = string
  default     = "chefall"
}

variable "duckdns_token" {
  description = "DuckDNS account token. Do not commit this value."
  type        = string
  sensitive   = true
}

variable "ingress_public_ip" {
  description = "Public IP address of the AKS ingress controller"
  type        = string
  default     = "40.114.208.193"
}

resource "null_resource" "duckdns_update" {
  triggers = {
    domain = var.duckdns_domain
    ip     = var.ingress_public_ip
  }

  provisioner "local-exec" {
    command = "curl.exe -s \"https://www.duckdns.org/update?domains=${var.duckdns_domain}&token=${var.duckdns_token}&ip=${var.ingress_public_ip}\""
  }
}

output "duckdns_url" {
  description = "DuckDNS public URL"
  value       = "http://${var.duckdns_domain}.duckdns.org"
}