output "status" {
  description = "ArgoCD Helm release status."
  value       = helm_release.argocd.status
}
