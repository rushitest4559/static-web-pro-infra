
data "azuread_application" "github_oidc_app" {
  display_name = "static-web-app"
}

resource "azurerm_storage_account" "sa" {
    name = "rushistaticsitesa${var.env}"
    account_replication_type = "LRS"
    account_tier = "Standard"
    resource_group_name = var.rg_name
    location = "East US 2"
    tags = {
      environment = var.env
    }
}

resource "azurerm_storage_account_static_website" "sasw" { 
  storage_account_id = azurerm_storage_account.sa.id
  index_document = "index.html"
  error_404_document = "index.html"
}

resource "azurerm_role_assignment" "ra" {
  scope = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = data.azuread_application.github_oidc_app.object_id
}