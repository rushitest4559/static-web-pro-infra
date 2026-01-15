resource "azurerm_resource_group" "rg" {
  name     = "static-web-rg-${var.env}"
  location = "East US 2"

  tags = {
    environment = var.env
  }
}