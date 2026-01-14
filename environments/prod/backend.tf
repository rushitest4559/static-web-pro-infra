terraform {

    required_version = "~> 1.14.0"

    backend "azurerm" {
        resource_group_name = "rg-state-files"
        storage_account_name = "staticwebrushi"
        container_name = "tfstate"
        key = "prod.terraform.tfstate"
        use_oidc = true
    }

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.90.0"
        }
    }

}

provider "azurerm" {
  features {
    resource_group {
        prevent_deletion_if_contains_resources = true
    }
  }
  use_oidc = true
}
