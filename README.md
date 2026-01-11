# 🛡️ Enterprise-Grade Static Site Infrastructure
A No-Ops, GitOps-driven deployment framework for Azure.

## 1. High-Level Architecture  
This project implements a __Zero Standing Access__ model. No human has write-access to the production environment; all changes are managed via __Identity Federation (OIDC)__ and __GitHub Actions__.
__🛠️The Tech Stack__
- __Cloud:__ Azure (Storage Accounts, Entra ID, Resource Groups)
- __IaC:__ Terraform (Folder-based separation)
- __CI/CD:__ GitHub Actions (Environments & OIDC)
- __Security:__ Microsoft Entra ID (OIDC), ABAC, RBAC

## 2. Structural Design
__📂 Repository Strategy__  
To separate concerns and reduce risk, the project is split into two independent repositories:
- infra-repo: Manages the "House" (Resource Groups, Storage Accounts, IAM, Networking).
- app-repo: Manages the "Furniture" (HTML/CSS files).
__🗄️ Resource Group Isolation__
We use __4 Resource Groups__ to strictly define the "Blast Radius":
- rg-state: Permanent storage for Terraform Backend.
- rg-dev: Volatile environment for rapid testing.
- rg-stage: A production-mirror for final validation.
- rg-prod: The mission-critical environment.

## 3. The Security Model
__🔑 Zero-Secret Identity (OIDC)__  
We use __OpenID Connect (OIDC)__ to connect GitHub to Azure.
- __No Client Secrets:__ No passwords are stored in GitHub.
- __Federated Credentials:__ Azure only trusts tokens coming from specific branches/environments in our specific GitHub Repos.
- __3 Scoped Identities:__ We use 3 separate Entra ID Applications (app-dev, app-stage, app-prod), each restricted to its own Resource Group.
__📜 State Management & ABAC__
- __Remote Backend:__ Terraform state is stored in a private Blob container in rg-state.
- __State Locking:__ Automatic Azure Blob Leasing prevents concurrent execution.
- __ABAC (Attribute-Based Access Control):__ Security is tightened by using conditions to ensure the app-dev identity can only touch the tfstate/dev/ path in the state bucket.

## 4. The "Golden Path" Lifecycle (CI/CD)
__🚀 Infrastructure Repo Flow__
__Pull Request:__ Triggers terraform validate and terraform plan for all folders (Dev/Stage/Prod).
__Merge to Main:__
- Auto-Deploy Dev: Changes applied immediately.
- Stage Gate: Wait for Lead Approval $\to$ Apply to Stage.
- Prod Gate: Wait for Lead Approval $\to$ Apply to Production.
__🌐 Application Repo Flow & "Safety Net"__
Every storage account has two containers: $web (Current) and previous-version (Backup).
__Backup Step:__ Before deployment, current $web files are copied to previous-version.
__Deploy Step:__ New files are uploaded to $web.
__The "Rollback Gate":__ After Prod deployment, the pipeline pauses at a __Rollback Environment.__
- If Approved: An "Instant Rollback" job swaps previous-version back into $web.
- If Skipped: The deployment is finalized.

## 5. Operations & Observability
- __No-Ops:__ Developers have Zero Write Access to the Azure Portal.
- __Monitoring:__ Team members are granted the Monitoring Reader role to view logs and metrics in Azure Monitor/Log Analytics.
- __Audit Trail:__ Every infrastructure change is linked to a Git Commit and a Peer-Reviewed Pull Request.

## 💡 Summary of Key Benefits
- __Security:__ No long-lived secrets; minimal human access.
- __Reliability:__ Sequential deployment (Dev $\to$ Stage $\to$ Prod) with mandatory approval gates.
- __Recovery:__ Instant, container-based rollback reduces MTTR (Mean Time To Recovery) to seconds.
- __Scale:__ Modular Terraform design allows for new environments to be added in minutes.