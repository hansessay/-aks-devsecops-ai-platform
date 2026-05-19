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