resource "azurerm_user_assigned_identity" "external_secrets" {
  name                = "external-secrets-mi"
  location            = var.location
  resource_group_name = module.resource_group.name

  tags = local.common_tags
}

resource "azurerm_federated_identity_credential" "external_secrets" {
  name                      = "external-secrets-federation"
  user_assigned_identity_id = azurerm_user_assigned_identity.external_secrets.id

  issuer   = module.aks.oidc_issuer_url
  subject  = "system:serviceaccount:3tirewebapp-dev:external-secrets-sa"
  audience = ["api://AzureADTokenExchange"]
}

resource "azurerm_role_assignment" "external_secrets_keyvault_user" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.external_secrets.principal_id
}

output "external_secrets_client_id" {
  value = azurerm_user_assigned_identity.external_secrets.client_id
}