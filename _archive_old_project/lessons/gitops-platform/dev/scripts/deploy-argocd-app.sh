#!/bin/bash
set -e

echo "🚀 Deploying ArgoCD Application..."

# Required variables check
: "${ENVIRONMENT:?ENVIRONMENT is required}"
: "${ARGOCD_NAMESPACE:=argocd}"
: "${APP_REPO_URL:?APP_REPO_URL is required}"
: "${APP_REPO_PATH:?APP_REPO_PATH is required}"

APP_NAME="3tirewebapp-${ENVIRONMENT}"

echo "📦 App Name: $APP_NAME"
echo "📦 Namespace: $ARGOCD_NAMESPACE"

# Get AKS credentials (must already exist via Terraform or manual step)
echo "🔐 Getting AKS credentials..."
az aks get-credentials \
  --resource-group "aks-gitops-rg-${ENVIRONMENT}" \
  --name "aks-gitops-cluster-${ENVIRONMENT}" \
  --overwrite-existing

echo "✅ Kubernetes connected"

# Check cluster
kubectl cluster-info

# Ensure ArgoCD namespace exists
kubectl get ns $ARGOCD_NAMESPACE >/dev/null 2>&1 || kubectl create ns $ARGOCD_NAMESPACE

# Wait for ArgoCD server
echo "⏳ Waiting for ArgoCD..."
kubectl rollout status deployment/argocd-server -n $ARGOCD_NAMESPACE --timeout=300s

# Render manifest safely (NO envsubst dependency)
echo "📝 Applying ArgoCD Application..."

cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${APP_NAME}
  namespace: ${ARGOCD_NAMESPACE}
spec:
  project: default
  source:
    repoURL: ${APP_REPO_URL}
    targetRevision: HEAD
    path: ${APP_REPO_PATH}
  destination:
    server: https://kubernetes.default.svc
    namespace: ${APP_NAME}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF

echo "🔍 Checking application status..."
kubectl get applications -n $ARGOCD_NAMESPACE

echo "🎉 Done!"