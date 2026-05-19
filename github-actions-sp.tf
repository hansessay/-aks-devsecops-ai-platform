resource "azuread_application" "github_actions" {
  display_name = "sp-github-actions-aks-acr"
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
}

resource "azuread_application_password" "github_actions" {
  application_id = azuread_application.github_actions.id
  display_name   = "github-actions-secret"
}

resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = data.azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.github_actions.object_id
}