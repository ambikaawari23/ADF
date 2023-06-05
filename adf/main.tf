terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }
}

provider "azurerm" {
  features {}

variable "environment" {
  description = "The environments in which the Azure Data Factory is being deployed."
  type        = list(string)
  default     = ["dev", "qa", "uat", "prod"]
}
  
resource "azurerm_resource_group" "rg" {
  name     = "ADF-AA"
  location = "West Europe"
}
  
resource "azurerm_data_factory" "example" {
  for_each            = "aa_adf_23_"(var.environment)
  name                = each.value
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }
  dynamic "github_configuration" {
    for_each = each.value == "dev" ? [1] : []
    content {
      account_name     = "Ambika-Awari"
      branch_name      = "aa"
      git_url          = "https://github.com/Ambika-Awari/adf"
      repository_name  = "adf"
      root_folder      = "/"
    }
  }
}

