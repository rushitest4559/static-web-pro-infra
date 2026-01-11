# 🛡️ Enterprise-Grade Static Site Infrastructure  
**A No-Ops, GitOps-driven deployment framework for Azure**

---

## 1. High-Level Architecture

This project implements a **Zero Standing Access** model.  
No human has write access to the production environment; all changes are managed via **Identity Federation (OIDC)** and **GitHub Actions**.

### 🛠️ Tech Stack
- **Cloud:** Azure (Storage Accounts, Entra ID, Resource Groups)
- **IaC:** Terraform (Folder-based separation)
- **CI/CD:** GitHub Actions (Environments & OIDC)
- **Security:** Microsoft Entra ID (OIDC), ABAC, RBAC

---

## 2. Structural Design

### 📂 Repository Strategy
To separate concerns and reduce risk, the project is split into two independent repositories:
- **infra-repo:** Manages the *House* (Resource Groups, Storage Accounts, IAM, Networking)
- **app-repo:** Manages the *Furniture* (HTML/CSS files)

### 🗄️ Resource Group Isolation
Four Resource Groups are used to strictly control blast radius:
- **rg-state:** Permanent storage for Terraform backend
- **rg-dev:** Volatile environment for rapid testing
- **rg-stage:** Production mirror for final validation
- **rg-prod:** Mission-critical production environment

---

## 3. Security Model

### 🔑 Zero-Secret Identity (OIDC)
OpenID Connect (OIDC) is used to connect GitHub to Azure:
- **No Client Secrets:** No credentials stored in GitHub
- **Federated Credentials:** Azure trusts tokens only from specific repos, branches, and environments
- **3 Scoped Identities:** Separate Entra ID applications (`app-dev`, `app-stage`, `app-prod`), each restricted to its own Resource Group

### 📜 State Management & ABAC
- **Remote Backend:** Terraform state stored in a private Blob container in `rg-state`
- **State Locking:** Azure Blob leasing prevents concurrent execution
- **ABAC:** Conditions ensure `app-dev` can only access `tfstate/dev/` paths in the state container

---

## 4. The “Golden Path” Lifecycle (CI/CD)

### 🚀 Infrastructure Repository Flow
**Pull Request**
- Runs `terraform validate` and `terraform plan` for Dev, Stage, and Prod

**Merge to Main**
- Auto-deploys **Dev**
- **Stage Gate:** Requires Lead approval → Apply to Stage
- **Prod Gate:** Requires Lead approval → Apply to Production

### 🌐 Application Repository Flow & Safety Net
Each Storage Account contains two containers:
- `$web` — Current version
- `previous-version` — Backup

**Backup Step**
- Current `$web` contents copied to `previous-version`

**Deploy Step**
- New files uploaded to `$web`

**Rollback Gate**
- After Prod deployment, pipeline pauses at a Rollback Environment:
  - **Approved:** Instantly restore `previous-version` to `$web`
  - **Skipped:** Deployment is finalized

---

## 5. Operations & Observability

- **No-Ops:** Developers have zero write access to the Azure Portal
- **Monitoring:** Team members use *Monitoring Reader* role for Azure Monitor and Log Analytics
- **Audit Trail:** Every infrastructure change is tied to a Git commit and peer-reviewed Pull Request

---

## 💡 Key Benefits

- **Security:** No long-lived secrets and minimal human access
- **Reliability:** Sequential Dev → Stage → Prod deployments with approval gates
- **Recovery:** Instant container-based rollback with MTTR measured in seconds
- **Scale:** Modular Terraform structure enables new environments in minutes
