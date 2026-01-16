# Static Web Pro – Infrastructure (GitOps with Terraform)

This repository contains Terraform infrastructure code for deploying a **production-style static website platform on Azure**, automated using **GitHub Actions + OIDC (no long-lived secrets)**.

---

## 🏗 What This Repository Does

- Provisions Azure infrastructure for **DEV / STAGE / PROD**
- Uses **Terraform** with remote state stored in **Azure Storage**
- Enforces a **PR-based GitOps workflow** (plan before apply)
- All infrastructure changes happen **only via GitHub Actions**
- No manual Azure Portal changes after initial bootstrap

---

## 🔐 Authentication & Security (One-Time Bootstrap)

> ⚠️ This setup is required **once** to enable secure CI/CD automation.

### Manually Configured in Azure

#### Identity
- Azure Entra ID Application (Service Principal)
- **Federated Credentials (OIDC)** configured:
  - Infra repo: PR workflow, main branch
  - App repo: dev, stage, prod

#### Permissions (Current State)
- **Contributor** role (broad, for demo simplicity)
- **Storage Blob Data Contributor** on Terraform state storage
- Required permissions for Terraform state access and role assignments

> ℹ️ Permissions are intentionally broader for demonstration and will be reduced (see Future Improvements).

#### State Infrastructure
- Dedicated Resource Group for Terraform state
- Storage Account with `tfstate` container

After this bootstrap, **no credentials or secrets are stored in GitHub**.

---

## 🔄 CI/CD Workflow (GitOps)

### Pull Request → `master`

- Runs:
  - `terraform init`
  - `terraform validate`
  - `terraform plan`
- Executes plans for:
  - `dev`
  - `stage`
  - `prod`
- Plan output is posted automatically to PR comments

> Purpose: visibility and review before merge

---

### Merge to `master`

- Runs `terraform apply`
- Applies environments sequentially:
  - dev → stage → prod
- Fully automated for demonstration

> ⚠️ In real production systems, **prod would be approval-gated**.

---

## 📦 State Management

- Remote backend: **Azure Storage**
- State isolation per environment
- Safe for team usage and concurrent workflows

---

## 🎥 Demo Videos

🎥 Demo: https://youtu.be/f-fXBQAMODQ

---

## 🔗 Related Repository

Static website application and deployment pipeline:  
👉 https://github.com/rushitest4559/static-web-pro-app

---

## 🛠 Tech Stack

- Terraform
- GitHub Actions
- Azure (Entra ID, RBAC, Storage)
- OIDC-based authentication

---

## 🚀 Future Improvements

Planned enhancements to move closer to real enterprise setups:

- Reduce permissions:
  - Replace subscription-level `Contributor`
  - Scope roles to Resource Group or individual resources
- Add approval gates:
  - Manual approval for `prod` apply
  - Environment protection rules in GitHub
- Drift detection:
  - Scheduled `terraform plan` for drift visibility
- Break-glass access:
  - Separate emergency role for incidents
- Policy enforcement:
  - Azure Policy / Terraform policy-as-code

---

## 🧠 Key Takeaway

This project demonstrates **GitOps-style infrastructure management**:
- Git as the source of truth
- Automated, auditable changes
- Secure, secretless CI/CD using OIDC
