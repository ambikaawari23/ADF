data "azurerm_client_config" "current" {
}
locals {
  strengths = {
   "adf01" = "adf124"
   "adf02" = "adf12401"
  }
}
resource "azurerm_resource_group" "example" {
  name     = "ADF-0124"
  location = "West Europe"
}

resource "azurerm_key_vault" "example" {
    for_each = local.strengths
    name  = each.value
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_storage_account" "example" {
    for_each = local.strengths
    name  = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
}

resource "azurerm_role_assignment" "example" {
   for_each = local.strengths
  scope                = azurerm_storage_account.example[each.value]
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_data_factory.example[each.value]
}

resource "azurerm_data_factory" "example" {
  for_each = local.strengths
  name  = each.value
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  github_configuration {
    account_name = "Ambika-Awari"
    branch_name = "main"
    git_url = "https://github.com/Ambika-Awari/adf"
    repository_name = "adf"
    root_folder = "/"
  }

     identity {
     type = "SystemAssigned"
   }
}

resource "azurerm_data_factory_linked_service_key_vault" "example" {
    for_each = local.strengths
    name  = each.value
  data_factory_id = azurerm_data_factory.example.id[each.value]
  key_vault_id    = azurerm_key_vault.example.id[each.value]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "example" {
      for_each = local.strengths
      name  = each.value
     data_factory_id   = azurerm_data_factory.example.id[each.value]
    connection_string =  azurerm_storage_account.example.[each.value]

}
