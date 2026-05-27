resource "azurerm_role_assignment" "aks_admin" {
  scope                = var.aks_cluster_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = var.current_principal_id
}

resource "azurerm_role_assignment" "aks_identity_operator" {
  scope                = var.resource_group_id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.aks_principal_id
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks_principal_id
}
