terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.87"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Single Naming Module for all resources
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix  = ["link"]
  suffix  = ["01"]
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  location = "southeastasia"
  name     = module.naming.resource_group.name_unique
}

# Create Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create an Azure File Share
resource "azurerm_storage_share" "fileshare" {
  name                 = "example-share"
  quota                = 5
  storage_account_name = azurerm_storage_account.storage.name
}

module "linked_service" {
  source = "../../"

  name                = module.naming.data_factory.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  linked_service_azure_blob_storage = {
    example = {
      name              = "blob-link"
      connection_string = azurerm_storage_account.storage.primary_connection_string
    }
  }

  linked_service_azure_file_storage = {
    example = {
      name              = "file-link"
      connection_string = azurerm_storage_account.storage.primary_connection_string
    }
  }

  tags = {
    "environment" = "linked-service"
  }
}
