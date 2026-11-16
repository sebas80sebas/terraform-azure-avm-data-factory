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
  prefix  = ["diag"]
  suffix  = ["01"]
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  location = "southeastasia"
  name     = module.naming.resource_group.name_unique
}

# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "this" {
  location            = azurerm_resource_group.rg.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.rg.name
}

module "diagnostic_settings" {
  source = "../../"

  name                = module.naming.data_factory.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  diagnostic_settings = {
    to_la = {
      name                  = "to-la"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
    }
  }
  
  tags = {
    "environment" = "diagnostics"
  }
}
