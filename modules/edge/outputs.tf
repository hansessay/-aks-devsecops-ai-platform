output "ddos_protection_plan_id" {
  value = azurerm_network_ddos_protection_plan.ddos.id
}

output "frontdoor_endpoint_host_name" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}

output "frontdoor_route_id" {
  value = azurerm_cdn_frontdoor_route.route.id
}

output "waf_policy_id" {
  value = azurerm_cdn_frontdoor_firewall_policy.waf.id
}

output "worker_rule_set_id" {
  value = azurerm_cdn_frontdoor_rule_set.worker_rules.id
}

output "custom_domain_host_name" {
  value = try(azurerm_cdn_frontdoor_custom_domain.custom[0].host_name, null)
}

output "custom_domain_id" {
  value = try(azurerm_cdn_frontdoor_custom_domain.custom[0].id, null)
}

output "custom_domain_validation_token" {
  value = try(azurerm_cdn_frontdoor_custom_domain.custom[0].validation_token, null)
}

output "custom_domain_cname_target" {
  value = azurerm_cdn_frontdoor_endpoint.endpoint.host_name
}
