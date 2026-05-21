# \# AKS DevSecOps AI Platform

# 

# This project demonstrates a production-style DevOps platform built on Azure Kubernetes Service (AKS) using Infrastructure as Code, GitOps principles, and automated DNS exposure.

# 

# \---

# 

# \## 🚀 Overview

# 

# The platform provisions and deploys a complete cloud-native application stack including:

# 

# \- Azure Kubernetes Service (AKS)

# \- NGINX Ingress Controller (via Helm)

# \- External DNS integration (DuckDNS)

# \- Multi-tier application (frontend, backend, PostgreSQL)

# \- Kubernetes manifests and policies

# \- Terraform-managed infrastructure

# 

# \---

# 

# \## 🧭 DuckDNS / Front Door DNS Setup

# 

# After deploying the `edge` module, create the following DNS records in DuckDNS for `cheikhibra.duckdns.org`:

# 

# 1. TXT record
#    - name: `_dnsauth.cheikhibra.duckdns.org`
#    - value: the output `edge_custom_domain_validation_token`
# 

# 2. CNAME record
#    - name: `cheikhibra.duckdns.org`
#    - value: the output `edge_custom_domain_cname_target`
# 

# Note: Front Door custom domain validation may take several minutes to complete.

# 

# \---

# 

# \## 🏗️ Architecture



