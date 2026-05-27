################################################################################
# ENVIRONMENT TEMPLATES - TERRAFORM CONFIGURATIONS
# 
# This directory contains environment-specific Terraform configurations for:
# - dev (development)
# - stage (staging)
# - prod (production)
#
# STRUCTURE:
# Each environment follows the same Terraform module structure but with
# different configurations and resource sizing.
################################################################################

# NOTE: Each environment should have symlinks or copies of the core Terraform files:
# - main.tf (references modules)
# - providers.tf (configure Kubernetes/Helm/Azure providers)
# - variables.tf (variable definitions)
# - outputs.tf (output values for bootstrap scripts)
# - terraform.tfvars (environment-specific values)
# - keyvault.tf (secrets management)
# - argocd.tf (removed - now in bootstrap module)
# - other environment-specific files

# RECOMMENDED STRUCTURE:
# 
# terraform/
# ├── environments/
# │   ├── dev/
# │   │   ├── main.tf → references bootstrap module
# │   │   ├── providers.tf
# │   │   ├── variables.tf
# │   │   ├── outputs.tf
# │   │   ├── terraform.tfvars (dev-specific values)
# │   │   ├── keyvault.tf
# │   │   └── ...
# │   │
# │   ├── stage/
# │   │   ├── main.tf → references bootstrap module
# │   │   ├── terraform.tfvars (stage-specific values)
# │   │   └── (symlink or copy other files from dev)
# │   │
# │   └── prod/
# │       ├── main.tf → references bootstrap module
# │       ├── terraform.tfvars (prod-specific values)
# │       └── (symlink or copy other files from dev)
# │
# └── modules/
#     ├── aks/
#     ├── network/
#     ├── resource_group/
#     ├── bootstrap/ (NEW - orchestrates ArgoCD + GitOps)
#     └── edge/

# TO SETUP A NEW ENVIRONMENT:
# 
# 1. Copy core Terraform files from dev to the new environment directory
# 2. Create environment-specific terraform.tfvars
# 3. Update variables.subscription_id if using different subscriptions
# 4. Run bootstrap:
#    cd terraform/environments/<env>
#    terraform init
#    .\bootstrap-automation.ps1 -Environment <env>
