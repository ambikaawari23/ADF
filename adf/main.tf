terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }

 backend "azurerm" {
    resource_group_name  = "storage001"
    storage_account_name = "stg22111"
    container_name       = "sst"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "environment" {
  description = "The environments in which the Azure Data Factory is being deployed."
  type        = list(string)
  default     = ["dev", "qa", "uat", "prod"]
}
  
  data "azurerm_client_config" "current" {
}
locals {
  strengths = {
   "adf01" = "aaadfdev"
   "adf02" = "aaadfqa"
   "adf03"= "aaadfuat"
   "adf04" ="aaadfprod"
   
  }
}
  
resource "azurerm_resource_group" "rg" {
  name     = "ADF-AA"
  location = "West Europe"
}
  
resource "azurerm_data_factory" "example" {
  for_each = local.strengths
  name  = each.value
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  identity {
    type = "SystemAssigned"
  }
  dynamic "github_configuration" {
    for_each = each.value == "dev" ? [1] : []
    content {
      account_name     = "Ambika-Awari"
      branch_name      = "main"
      git_url          = "https://github.com/Ambika-Awari/adf_aa"
      repository_name  = "adf_aa"
      root_folder      = "/"
    }
  }
}

