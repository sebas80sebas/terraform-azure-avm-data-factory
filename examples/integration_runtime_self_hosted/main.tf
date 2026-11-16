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
  prefix  = ["shir"]
  suffix  = ["01"]
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  location = "southeastasia"
  name     = module.naming.resource_group.name_unique
}

# Create Resource Group for Host Data Factory
resource "azurerm_resource_group" "host" {
  location = "southeastasia"
  name     = "${module.naming.resource_group.name_unique}-host"
}

# Create Host Data Factory with Managed Identity
resource "azurerm_data_factory" "host" {
  name                = "${module.naming.data_factory.name_unique}-host"
  location            = azurerm_resource_group.host.location
  resource_group_name = azurerm_resource_group.host.name

  identity {
    type = "SystemAssigned"
  }
}

# Create Host Self-Hosted Integration Runtime
resource "azurerm_data_factory_integration_runtime_self_hosted" "host" {
  name            = module.naming.data_factory_integration_runtime_managed.name_unique
  data_factory_id = azurerm_data_factory.host.id
}

# Grant the consuming Data Factory permission to access the host IR
resource "azurerm_role_assignment" "shir_sharing" {
  scope                = azurerm_data_factory_integration_runtime_self_hosted.host.id
  role_definition_name = "Contributor"
  principal_id         = module.integration_runtime_self_hosted.resource.identity[0].principal_id
}

module "integration_runtime_self_hosted" {
  source = "../../"

  name                = module.naming.data_factory.name_unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  managed_identities = {
    system_assigned = true
  }

  integration_runtime_self_hosted = {
    example = {
      name        = module.naming.data_factory_integration_runtime_managed.name_unique
      description = "Linked Self-Hosted IR"
      rbac_authorization = {
        resource_id = azurerm_data_factory_integration_runtime_self_hosted.host.id
      }
    }
  }

  tags = {
    "environment" = "shir"
  }
}
