resource "null_resource" "external_secrets_operator" {
  count = var.enable_key_vault ? 1 : 0

  triggers = {
    cluster_id    = var.cluster_id
    environment   = var.environment
    key_vault_id  = var.key_vault_id
    kubelet_id    = var.kubelet_identity_client_id
    secrets_ready = "${var.postgres_username_secret_id}-${var.postgres_password_secret_id}-${var.postgres_database_secret_id}-${var.postgres_connection_secret_id}"
  }

  provisioner "local-exec" {
    working_dir = var.root_path
    command     = "./scripts/install-external-secrets.sh ${var.resource_group_name} ${var.cluster_name} ${var.key_vault_uri} ${var.kubelet_identity_client_id} ${var.environment} ${var.postgres_username_secret_name} ${var.postgres_password_secret_name} ${var.postgres_database_secret_name} ${var.postgres_connection_secret_name}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "./scripts/cleanup-external-secrets.sh ${self.triggers.environment}"
  }
}

resource "null_resource" "goal_tracker_app" {
  triggers = {
    cluster_id       = var.cluster_id
    argocd_ready     = var.argocd_status
    script_hash      = filemd5("${var.scripts_path}/deploy-argocd-app.sh")
    manifest_hash    = filemd5("${var.manifests_path}/argocd-app-manifest.yaml")
    environment      = var.environment
    argocd_namespace = var.argocd_namespace
  }

  provisioner "local-exec" {
    working_dir = var.root_path
    command     = "./scripts/deploy-argocd-app.sh"

    environment = {
      ENVIRONMENT      = var.environment
      ARGOCD_NAMESPACE = var.argocd_namespace
      GITOPS_REPO_URL  = var.gitops_repo_url
      APP_REPO_URL     = var.app_repo_url
      APP_REPO_PATH    = var.app_repo_path
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "kubectl delete application 3tirewebapp-${self.triggers.environment} -n ${self.triggers.argocd_namespace} --ignore-not-found=true"
  }
}
