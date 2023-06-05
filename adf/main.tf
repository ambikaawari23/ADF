data "azurerm_client_config" "current" {
}
locals {
  strengths = {
   "adf01" = "adf124"
   "adf02" = "adf12401"
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "ADF-AA"
  location = "West Europe"
}

resource "azurerm_data_factory" "adfaa" {
#   for_each            = local.strengths
  name                = "adf23${{ var.environment }}
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }
  dynamic "github_configuration" {
    for_each = var.environment == "dev" ? [1] : []
    content {
      account_name     = "Ambika-Awari"
      branch_name      = "main"
      git_url          = "https://github.com/Ambika-Awari/adf"
      repository_name  = "adf"
      root_folder      = "/"
    }
  }
