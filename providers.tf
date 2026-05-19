############################################
# TERRAFORM + PROVIDERS
############################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

############################################
# AZURE PROVIDER
############################################
provider "azurerm" {
  features {}

  subscription_id = "b9314784-3340-472d-9008-efe320576fa1"
}

provider "azuread" {}

############################################
# KUBERNETES PROVIDER
############################################
provider "kubernetes" {
  config_path = "~/.kube/config"
}

############################################
# HELM PROVIDER
############################################
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}