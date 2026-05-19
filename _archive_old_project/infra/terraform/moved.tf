moved {
  from = azurerm_resource_group.main
  to   = module.resource_group.azurerm_resource_group.main
}

moved {
  from = azurerm_kubernetes_cluster.main
  to   = module.aks.azurerm_kubernetes_cluster.main
}

moved {
  from = time_sleep.wait_for_cluster
  to   = module.aks.time_sleep.wait_for_cluster
}

moved {
  from = azurerm_role_assignment.aks_admin
  to   = module.rbac.azurerm_role_assignment.aks_admin
}

moved {
  from = azurerm_role_assignment.aks_identity_operator
  to   = module.rbac.azurerm_role_assignment.aks_identity_operator
}

moved {
  from = azurerm_role_assignment.aks_network_contributor
  to   = module.rbac.azurerm_role_assignment.aks_network_contributor
}

moved {
  from = random_string.suffix
  to   = module.keyvault.random_string.suffix
}

moved {
  from = random_password.postgres_password
  to   = module.keyvault.random_password.postgres_password
}

moved {
  from = azurerm_key_vault.main
  to   = module.keyvault.azurerm_key_vault.main
}

moved {
  from = azurerm_key_vault_secret.postgres_username
  to   = module.keyvault.azurerm_key_vault_secret.postgres_username
}

moved {
  from = azurerm_key_vault_secret.postgres_password
  to   = module.keyvault.azurerm_key_vault_secret.postgres_password
}

moved {
  from = azurerm_key_vault_secret.postgres_database
  to   = module.keyvault.azurerm_key_vault_secret.postgres_database
}

moved {
  from = azurerm_key_vault_secret.postgres_connection_string
  to   = module.keyvault.azurerm_key_vault_secret.postgres_connection_string
}

moved {
  from = kubernetes_namespace.argocd
  to   = module.argocd.kubernetes_namespace.argocd
}

moved {
  from = helm_release.argocd
  to   = module.argocd.helm_release.argocd
}

moved {
  from = null_resource.external_secrets_operator
  to   = module.app.null_resource.external_secrets_operator
}

moved {
  from = null_resource.goal_tracker_app
  to   = module.app.null_resource.goal_tracker_app
}
