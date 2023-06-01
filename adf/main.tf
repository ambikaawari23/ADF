resource "azurerm_resource_group" "rg" {
  name     = "adf-resources"
  location = "West Europe"
}

resource "azurerm_data_factory" "adf01" {
  name                = "aa_adf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}