#!/bin/bash
set -euo pipefail

ENVIRONMENT=$1

NAMESPACE="3tirewebapp-${ENVIRONMENT}"
ESO_NAMESPACE="external-secrets-system"

echo "🧹 Cleaning External Secrets resources..."

# Delete ExternalSecret (namespaced)
kubectl delete externalsecret postgres-credentials -n "$NAMESPACE" --ignore-not-found=true || true

# Delete SecretStore (CLUSTER-scoped → no namespace!)
kubectl delete secretstore azure-keyvault-store --ignore-not-found=true || true

echo "📦 Uninstalling External Secrets Operator..."
helm uninstall external-secrets -n "$ESO_NAMESPACE" || true

echo "🧹 (Optional) Cleaning namespaces..."

kubectl delete namespace "$NAMESPACE" --ignore-not-found=true --wait=false || true

echo "⏳ Waiting a few seconds for cleanup..."
sleep 10

echo "✅ Cleanup completed!"