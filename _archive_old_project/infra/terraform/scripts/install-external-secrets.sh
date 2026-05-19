#!/bin/bash
set -euo pipefail

echo "🔐 External Secrets Operator Installation"

# Inputs
RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2
KEY_VAULT_URI=$3
KUBELET_IDENTITY_ID=$4
ENVIRONMENT=$5
POSTGRES_USERNAME_SECRET=$6
POSTGRES_PASSWORD_SECRET=$7
POSTGRES_DATABASE_SECRET=$8
POSTGRES_CONNECTION_STRING_SECRET=$9

NAMESPACE="3tirewebapp-${ENVIRONMENT}"
ESO_NAMESPACE="external-secrets-system"

echo "📦 Connecting to AKS..."
az aks get-credentials \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --name "$CLUSTER_NAME" \
  --overwrite-existing

echo "📦 Creating namespaces..."
kubectl create namespace "$ESO_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

echo "📦 Installing External Secrets Operator..."
helm repo add external-secrets https://charts.external-secrets.io || true
helm repo update

helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace "$ESO_NAMESPACE" \
  --create-namespace \
  --set installCRDs=true \
  --wait --timeout=300s

echo "⏳ Waiting for ESO pods..."
kubectl rollout status deployment -n "$ESO_NAMESPACE" --timeout=300s

echo "🔑 Creating SecretStore..."
cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: azure-keyvault-store
  namespace: ${NAMESPACE}
spec:
  provider:
    azurekv:
      vaultUrl: ${KEY_VAULT_URI}
      authType: ManagedIdentity
      identityId: ${KUBELET_IDENTITY_ID}
EOF

echo "🎯 Creating ExternalSecret..."
cat <<EOF | kubectl apply -f -
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: postgres-credentials
  namespace: ${NAMESPACE}
spec:
  refreshInterval: 1m
  secretStoreRef:
    name: azure-keyvault-store
    kind: SecretStore
  target:
    name: postgres-credentials-from-kv
    creationPolicy: Owner
  data:
    - secretKey: POSTGRES_USER
      remoteRef:
        key: ${POSTGRES_USERNAME_SECRET}
    - secretKey: POSTGRES_PASSWORD
      remoteRef:
        key: ${POSTGRES_PASSWORD_SECRET}
    - secretKey: POSTGRES_DB
      remoteRef:
        key: ${POSTGRES_DATABASE_SECRET}
    - secretKey: DATABASE_URL
      remoteRef:
        key: ${POSTGRES_CONNECTION_STRING_SECRET}
EOF

echo "⏳ Waiting for ExternalSecret (optional check)..."
kubectl wait --for=condition=Ready externalsecret/postgres-credentials -n "$NAMESPACE" --timeout=300s || true

echo "🔍 Checking secret..."
kubectl get secret postgres-credentials-from-kv -n "$NAMESPACE" || echo "⚠️ Secret not created yet (check Key Vault permissions)"

echo "🎉 Done!"