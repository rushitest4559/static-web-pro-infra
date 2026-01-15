# Static Web Pro Infra

This repository contains Terraform infrastructure code for deploying a **production-ready static website platform on Azure**, fully automated via **GitHub Actions + OIDC**.

---

## 🏗 What This Repo Does

- Provisions Azure infrastructure for **DEV / STAGE / PROD**
- Uses **Terraform** with remote state stored in **Azure Storage**
- Enforces **PR-based workflow** with plan-before-apply
- Zero long-lived secrets (**OIDC only**)

---

## 🔐 Authentication & Security (One-Time Manual Setup)

Before automation, the following was configured manually in Azure:

### Created

- Entra ID App (Service Principal)
- Configured **5 Federated Credentials**
  - 2 for infra repo (main + PR)
  - 3 for app repo (dev, stage, prod)

### Granted Roles

- **Contributor** on subscription
- **Storage Blob Data Contributor** on Terraform state storage
- Permissions to list Entra ID apps
- Permission to assign roles to storage accounts

### Resources Created

- Dedicated resource group for Terraform state
- Storage account + `tfstate` container

After this, **all infrastructure is managed only via CI/CD**.

---

## 🔄 CI/CD Workflow

### On Pull Request → `master`

- Runs `terraform init / validate / plan`
- Executes plan for **dev, stage, prod**
- Automatically posts plan output to PR comments

### On Merge to `master`

- Runs `terraform apply`
- Applies infra sequentially for **dev, stage, prod**
- Fully automated, no manual steps

---

## 📦 State Management

- Remote backend: **Azure Storage**
- State isolation per environment
- Safe for team usage and parallel runs

---

## 🔗 Related Repository

Static website application + deployment pipeline:  
👉 https://github.com/rushitest4559/static-web-pro-app

---

## 🛠 Tech Stack

- **Terraform**
- **GitHub Actions**
- **Azure** (Entra ID, Storage, RBAC)
- **OIDC Authentication**
