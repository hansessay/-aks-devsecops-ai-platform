################################################################################
# BOOTSTRAP MODULE - Orchestrates complete platform initialization
# This module handles:
# - AKS credentials setup
# - ArgoCD installation & configuration
# - Root app deployment
# - Secret initialization
################################################################################

locals {
  # Bootstrap scripts location (relative to module)
  scripts_path = "${path.root}/../../gitops-configs/bootstrap"
}

################################################################################
# 1. LOCAL FILE - Bootstrap script outputs for kubectl access
################################################################################
resource "local_file" "kubeconfig_path" {
  content  = var.kube_config_path
  filename = "${path.root}/.bootstrap/kubeconfig_path.txt"

  lifecycle {
    ignore_changes = [content]
  }
}

################################################################################
# 2. ARGOCD NAMESPACE (Kubernetes)
################################################################################
resource "kubernetes_namespace" "argocd" {
  count = var.enable_argocd ? 1 : 0

  metadata {
    name = var.argocd_namespace

    labels = {
      "app.kubernetes.io/name"       = "argocd"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  depends_on = [local_file.kubeconfig_path]
}

################################################################################
# 3. ARGOCD HELM RELEASE
################################################################################
resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = kubernetes_namespace.argocd[0].metadata[0].name
  create_namespace = false
  version          = var.argocd_chart_version

  values = [
    yamlencode({
      server = {
        service = {
          type = var.argocd_service_type
        }
        insecure = var.argocd_insecure_mode
      }

      configs = {
        url = var.argocd_url

        repositories = var.gitops_repo_config
      }

      repoServer = {
        replicas = var.argocd_replicas
      }

      application = {
        instances = {
          ls = var.argocd_instances
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.argocd
  ]
}

################################################################################
# 4. ARGOCD PROJECT (for GitOps apps)
################################################################################
resource "kubernetes_manifest" "argocd_project" {
  count = var.enable_argocd ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"

    metadata = {
      name      = "platform"
      namespace = kubernetes_namespace.argocd[0].metadata[0].name
    }

    spec = {
      description = "Platform and Application deployment project"

      sourceRepos = [
        var.gitops_repo_url
      ]

      destinations = [
        {
          namespace = "*"
          server    = "*"
        }
      ]

      clusterResourceWhitelist = [
        {
          group = "*"
          kind  = "*"
        }
      ]
    }
  }

  depends_on = [helm_release.argocd]
}

################################################################################
# 5. ARGOCD ROOT APPLICATION (Platform)
################################################################################
resource "kubernetes_manifest" "argocd_app_platform_root" {
  count = var.enable_argocd && var.enable_root_app ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "platform-root"
      namespace = kubernetes_namespace.argocd[0].metadata[0].name
    }

    spec = {
      project = kubernetes_manifest.argocd_project[0].manifest.metadata.name

      source = {
        repoURL        = var.gitops_repo_url
        targetRevision = var.gitops_repo_revision
        path           = var.platform_app_path
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.argocd[0].metadata[0].name
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }

        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }

  depends_on = [kubernetes_manifest.argocd_project]
}

################################################################################
# 6. ARGOCD ROOT APPLICATION (Apps)
################################################################################
resource "kubernetes_manifest" "argocd_app_apps_root" {
  count = var.enable_argocd && var.enable_root_app ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "app-root"
      namespace = kubernetes_namespace.argocd[0].metadata[0].name
    }

    spec = {
      project = kubernetes_manifest.argocd_project[0].manifest.metadata.name

      source = {
        repoURL        = var.gitops_repo_url
        targetRevision = var.gitops_repo_revision
        path           = var.apps_app_path
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }

        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }

  depends_on = [kubernetes_manifest.argocd_project]
}

################################################################################
# 7. BOOTSTRAP MONITORING - External Secrets Store (Key Vault integration)
################################################################################
resource "kubernetes_manifest" "external_secrets_store" {
  count = var.enable_external_secrets ? 1 : 0

  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "SecretStore"

    metadata = {
      name      = "azure-vault"
      namespace = kubernetes_namespace.argocd[0].metadata[0].name
    }

    spec = {
      provider = {
        azurekv = {
          auth = {
            workloadIdentity = {
              serviceAccountRef = {
                name = "external-secrets-sa"
              }
            }
          }

          vaultUrl = var.keyvault_uri
          tenantId = var.azure_tenant_id
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}

################################################################################
# LOCAL OUTPUT - Status file
################################################################################
resource "local_file" "bootstrap_status" {
  count = var.enable_argocd ? 1 : 0

  content = <<-EOT
# Bootstrap Status - ${timestamp()}

## ArgoCD Information
ArgoCD Namespace: ${kubernetes_namespace.argocd[0].metadata[0].name}
ArgoCD Service Type: ${var.argocd_service_type}
ArgoCD Chart Version: ${var.argocd_chart_version}

## GitOps Configuration
Repository URL: ${var.gitops_repo_url}
Repository Branch: ${var.gitops_repo_revision}
Platform App Path: ${var.platform_app_path}
Apps App Path: ${var.apps_app_path}

## Next Steps
1. Retrieve ArgoCD password: kubectl get secret argocd-initial-admin-secret -n ${kubernetes_namespace.argocd[0].metadata[0].name} -o jsonpath="{.data.password}" | base64 -d
2. Port-forward to ArgoCD: kubectl port-forward svc/argocd-server -n ${kubernetes_namespace.argocd[0].metadata[0].name} 8080:443
3. Monitor sync status: kubectl get applications -n ${kubernetes_namespace.argocd[0].metadata[0].name} -w

## Bootstrap Artifacts
Kubeconfig: ${local_file.kubeconfig_path.filename}
Status File: ${path.root}/.bootstrap/bootstrap_status.txt
  EOT

  filename = "${path.root}/.bootstrap/bootstrap_status.txt"

  depends_on = [
    kubernetes_namespace.argocd,
    helm_release.argocd
  ]
}
