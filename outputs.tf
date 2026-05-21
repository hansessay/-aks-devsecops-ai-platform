output "resource_group_name" {
  value = module.resource_group.name
}
output "github_client_id" {
  value = azuread_application.github_actions.client_id
}

output "github_client_secret" {
  value     = azuread_application_password.github_actions.value
  sensitive = true
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = "b9314784-3340-472d-9008-efe320576fa1"
}

output "edge_frontdoor_endpoint_host_name" {
  value = module.edge.frontdoor_endpoint_host_name
}

output "edge_frontdoor_route_id" {
  value = module.edge.frontdoor_route_id
}

output "edge_ddos_protection_plan_id" {
  value = module.edge.ddos_protection_plan_id
}

output "edge_waf_policy_id" {
  value = module.edge.waf_policy_id
}

output "edge_worker_rule_set_id" {
  value = module.edge.worker_rule_set_id
}

output "edge_custom_domain_host_name" {
  value = module.edge.custom_domain_host_name
}

output "edge_custom_domain_validation_token" {
  value = module.edge.custom_domain_validation_token
}

output "edge_custom_domain_cname_target" {
  value = module.edge.custom_domain_cname_target
}