# Terraform Azure AVM Data Factory Module

This module is an **Azure Verified Module (AVM) Wrapper** for deploying Azure Data Factory resources. It provides a simplified interface for the official Microsoft AVM module and can be integrated into Azure landing zone deployments.

## Features

- **Core Factory**: Deploy Azure Data Factory with Git/VSTS configuration.
- **Integration Runtimes**: Support for Self-Hosted Integration Runtimes (shared or dedicated).
- **Linked Services**: Built-in support for Azure Blob Storage, Azure SQL, Key Vault, Databricks, and more.
- **Security**: Managed Identities (System & User), Customer Managed Keys (CMK), and RBAC support.
- **Networking**: Managed Virtual Network and Private Endpoint support.
- **Observability**: Integrated Diagnostic Settings and Telemetry.

## Folder Structure

The module follows the standard Azure Verified Module (AVM) layout:

- `.config/`: AVM configuration metadata.
- `.github/`: CI/CD workflows for validation.
- `examples/`: Comprehensive scenarios.
- `main.tf`: Core logic wrapping the official AVM module.
- `variables.tf`: Input variable definitions matching official standards.
- `outputs.tf`: Module outputs.
- `CHANGELOG`: Version history and updates.

## Testing and Verification

To verify that this module works correctly, you can use the provided examples in the `examples/` folder.

### 1. Manual Validation

Run the following commands inside the module root to validate the code:

```bash
terraform init -backend=false
terraform validate
```

### 2. Integration Test (Plan)

To see what resources will be created without actually deploying them:

```bash
cd examples/basic
# Set your Azure subscription (required)
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
terraform init
terraform plan
```

### 3. Full Deployment Test

If you have a testing environment, you can deploy any of the examples:

```bash
cd examples/basic
terraform apply -auto-approve
# After verification, destroy the resources
terraform destroy -auto-approve
```

## Usage

```hcl
module "datafactory" {
  source = "git::https://github.com/sebas80sebas/terraform-azure-avm-data-factory.git"

  name                = "my-data-factory"
  resource_group_name = "my-rg"
  location            = "uksouth"

  public_network_enabled = true
  
  tags = {
    environment = "dev"
  }
}
```

## Examples

- [Basic](./examples/basic): Basic Data Factory deployment.
- [Diagnostic Settings](./examples/diagnostic_settings): Data Factory with Azure Monitor diagnostics.
- [Self-Hosted IR](./examples/integration_runtime_self_hosted): Shared Self-Hosted Integration Runtime configuration.
- [Linked Service](./examples/linked_service): Data Factory with Linked Services to Azure Blob Storage and Azure File Storage.

## Requirements

| Name      | Version            |
|-----------|--------------------|
| terraform | >= 1.9, < 2.0      |
| azurerm   | ~> 4.0             |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9, < 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_datafactory"></a> [datafactory](#module\_datafactory) | Azure/avm-res-datafactory-factory/azurerm | 0.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_credential_service_principal"></a> [credential\_service\_principal](#input\_credential\_service\_principal) | A map of service principal credentials to create. | <pre>map(object({<br/>    name = string<br/>    data_factory_id = optional(string)<br/>    tenant_id = string<br/>    service_principal_id = string<br/>    annotations = optional(list(string), null)<br/>    description = optional(string, null)<br/>    service_principal_key = optional(object({<br/>      linked_service_name = string<br/>      secret_name = string<br/>      secret_version = optional(string, null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_credential_user_managed_identity"></a> [credential\_user\_managed\_identity](#input\_credential\_user\_managed\_identity) | A map of user managed identity credentials to create. | <pre>map(object({<br/>    name = string<br/>    data_factory_id = optional(string)<br/>    identity_id = string<br/>    annotations = optional(list(string), null)<br/>    description = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_customer_managed_key_id"></a> [customer\_managed\_key\_id](#input\_customer\_managed\_key\_id) | The ID of the Key Vault Key to use for Customer Managed Keys. | `string` | `null` | no |
| <a name="input_customer_managed_key_identity_id"></a> [customer\_managed\_key\_identity\_id](#input\_customer\_managed\_key\_identity\_id) | The ID of the User Assigned Identity to use for Customer Managed Keys. | `string` | `null` | no |
| <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings) | A map of diagnostic settings to create. | <pre>map(object({<br/>    name                                     = optional(string, null)<br/>    log_categories                           = optional(set(string), [])<br/>    log_groups                               = optional(set(string), ["allLogs"])<br/>    metric_categories                        = optional(set(string), ["AllMetrics"])<br/>    log_analytics_destination_type           = optional(string, "Dedicated")<br/>    workspace_resource_id                    = optional(string, null)<br/>    storage_account_resource_id              = optional(string, null)<br/>    event_hub_authorization_rule_resource_id = optional(string, null)<br/>    event_hub_name                           = optional(string, null)<br/>    marketplace_partner_resource_id          = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | Controls whether telemetry is enabled for the module. | `bool` | `true` | no |
| <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration) | VCS configuration for GitHub. | <pre>object({<br/>    account_name       = string<br/>    branch_name        = string<br/>    git_url            = optional(string, null)<br/>    repository_name    = string<br/>    root_folder        = string<br/>    publishing_enabled = optional(bool, true)<br/>  })</pre> | `null` | no |
| <a name="input_global_parameters"></a> [global\_parameters](#input\_global\_parameters) | List of global parameters to define in the Data Factory. | <pre>list(object({<br/>    name  = string<br/>    type  = string<br/>    value = any<br/>  }))</pre> | `[]` | no |
| <a name="input_integration_runtime_self_hosted"></a> [integration\_runtime\_self\_hosted](#input\_integration\_runtime\_self\_hosted) | A map of self-hosted integration runtimes to create. | <pre>map(object({<br/>    data_factory_id                              = optional(string)<br/>    name                                         = string<br/>    description                                  = optional(string, null)<br/>    self_contained_interactive_authoring_enabled = optional(bool, null)<br/>    rbac_authorization = optional(object({<br/>      resource_id = string<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_service_azure_blob_storage"></a> [linked\_service\_azure\_blob\_storage](#input\_linked\_service\_azure\_blob\_storage) | A map of Azure Blob Storage linked services to create. | <pre>map(object({<br/>    name                       = string<br/>    description                = optional(string, null)<br/>    integration_runtime_name   = optional(string, null)<br/>    annotations                = optional(list(string), null)<br/>    parameters                 = optional(map(string), null)<br/>    additional_properties      = optional(map(string), null)<br/>    connection_string          = optional(string, null)<br/>    connection_string_insecure = optional(string, null)<br/>    sas_uri                    = optional(string, null)<br/>    service_endpoint           = optional(string, null)<br/>    use_managed_identity       = optional(bool, null)<br/>    service_principal_id       = optional(string, null)<br/>    service_principal_key      = optional(string, null)<br/>    storage_kind               = optional(string, null)<br/>    tenant_id                  = optional(string, null)<br/>    key_vault_sas_token = optional(object({<br/>      linked_service_name = string<br/>      secret_name         = string<br/>    }), null)<br/>    service_principal_linked_key_vault_key = optional(object({<br/>      linked_service_name = string<br/>      secret_name         = string<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_service_azure_file_storage"></a> [linked\_service\_azure\_file\_storage](#input\_linked\_service\_azure\_file\_storage) | A map of Azure File Storage linked services to create. | <pre>map(object({<br/>    name                     = string<br/>    data_factory_id          = optional(string)<br/>    description              = optional(string, null)<br/>    host                     = optional(string, null)<br/>    integration_runtime_name = optional(string, null)<br/>    annotations              = optional(list(string), null)<br/>    parameters               = optional(map(string), null)<br/>    password                 = optional(string, null)<br/>    user_id                  = optional(string, null)<br/>    additional_properties    = optional(map(string), null)<br/>    connection_string        = string<br/>    file_share               = optional(string, null)<br/>    key_vault_password = optional(object({<br/>      linked_service_name = string<br/>      secret_name         = string<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_service_azure_sql_database"></a> [linked\_service\_azure\_sql\_database](#input\_linked\_service\_azure\_sql\_database) | A map of Azure SQL Database linked services to create. | <pre>map(object({<br/>    name                     = string<br/>    data_factory_id          = optional(string)<br/>    connection_string        = optional(string, null)<br/>    use_managed_identity     = optional(bool, null)<br/>    service_principal_id     = optional(string, null)<br/>    service_principal_key    = optional(string, null)<br/>    tenant_id                = optional(string, null)<br/>    description              = optional(string, null)<br/>    integration_runtime_name = optional(string, null)<br/>    annotations              = optional(list(string), null)<br/>    parameters               = optional(map(string), null)<br/>    additional_properties    = optional(map(string), null)<br/>    credential_name          = optional(string, null)<br/>    key_vault_connection_string = optional(object({<br/>      linked_service_name = string<br/>      secret_name         = string<br/>    }), null)<br/>    key_vault_password = optional(object({<br/>      linked_service_name = string<br/>      secret_name         = string<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_service_data_lake_storage_gen2"></a> [linked\_service\_data\_lake\_storage\_gen2](#input\_linked\_service\_data\_lake\_storage\_gen2) | A map of Data Lake Storage Gen2 linked services to create. | <pre>map(object({<br/>    name                   = string<br/>    data_factory_id        = optional(string)<br/>    description            = optional(string, null)<br/>    integration_runtime_name = optional(string, null)<br/>    annotations            = optional(list(string), null)<br/>    parameters             = optional(map(string), null)<br/>    additional_properties  = optional(map(string), null)<br/>    url                    = string<br/>    storage_account_key    = optional(string, null)<br/>    use_managed_identity   = optional(bool, null)<br/>    service_principal_id   = optional(string, null)<br/>    service_principal_key  = optional(string, null)<br/>    tenant                 = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_service_databricks"></a> [linked\_service\_databricks](#input\_linked\_service\_databricks) | A map of Azure Databricks linked services to create. | <pre>map(object({<br/>    adb_domain               = string<br/>    data_factory_id          = optional(string)<br/>    name                     = string<br/>    additional_properties    = optional(map(string), null)<br/>    annotations              = optional(list(string), null)<br/>    description              = optional(string, null)<br/>    integration_runtime_name = optional(string, null)<br/>    parameters               = optional(map(string), null)<br/>    access_token             = optional(string, null)<br/>    msi_work_space_resource_id = optional(string, null)<br/>    key_vault_password = optional(object({<br/>      linked_service_name = string<br/>      secret_name         = string<br/>    }), null)<br/>    existing_cluster_id      = optional(string, null)<br/>    instance_pool = optional(object({<br/>      instance_pool_id      = string<br/>      cluster_version       = string<br/>      min_number_of_workers = optional(number, 1)<br/>      max_number_of_workers = optional(number, null)<br/>    }), null)<br/>    new_cluster_config = optional(object({<br/>      cluster_version       = string<br/>      node_type             = string<br/>      driver_node_type      = optional(string, null)<br/>      max_number_of_workers = optional(number, null)<br/>      min_number_of_workers = optional(number, 1)<br/>      spark_config          = optional(map(string), null)<br/>      spark_environment_variables = optional(map(string), null)<br/>      custom_tags           = optional(map(string), null)<br/>      init_scripts          = optional(list(string), null)<br/>      log_destination       = optional(string, null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_linked_service_key_vault"></a> [linked\_service\_key\_vault](#input\_linked\_service\_key\_vault) | A map of Key Vault linked services to create. | <pre>map(object({<br/>    name                     = string<br/>    data_factory_id          = optional(string)<br/>    key_vault_id             = string<br/>    description              = optional(string, null)<br/>    integration_runtime_name = optional(string, null)<br/>    annotations              = optional(list(string), null)<br/>    parameters               = optional(map(string), null)<br/>    additional_properties    = optional(map(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the resource exists. | `string` | n/a | yes |
| <a name="input_lock"></a> [lock](#input\_lock) | The Resource Lock configuration. | <pre>object({<br/>    kind = string<br/>    name = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | Managed identities configuration. | <pre>object({<br/>    system_assigned            = optional(bool, false)<br/>    user_assigned_resource_ids = optional(set(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | Is Managed Virtual Network enabled? | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Data Factory. | `string` | n/a | yes |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | A map of private endpoints to create. | <pre>map(object({<br/>    name = optional(string, null)<br/>    role_assignments = optional(map(object({<br/>      role_definition_id_or_name             = string<br/>      principal_id                           = string<br/>      description                            = optional(string, null)<br/>      skip_service_principal_aad_check       = optional(bool, false)<br/>      condition                              = optional(string, null)<br/>      condition_version                      = optional(string, null)<br/>      delegated_managed_identity_resource_id = optional(string, null)<br/>      principal_type                         = optional(string, null)<br/>    })), {})<br/>    lock = optional(object({<br/>      kind = string<br/>      name = optional(string, null)<br/>    }), null)<br/>    tags                                    = optional(map(string), null)<br/>    subnet_resource_id                      = string<br/>    private_dns_zone_group_name             = optional(string, "default")<br/>    private_dns_zone_resource_ids           = optional(set(string), [])<br/>    application_security_group_associations = optional(map(string), {})<br/>    private_service_connection_name         = optional(string, null)<br/>    network_interface_name                  = optional(string, null)<br/>    location                                = optional(string, null)<br/>    resource_group_name                     = optional(string, null)<br/>    ip_configurations = optional(map(object({<br/>      name               = string<br/>      private_ip_address = string<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group) | Whether to manage the DNS zone group for private endpoints. | `bool` | `true` | no |
| <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled) | Is the Data Factory visible to the public network? | `bool` | `false` | no |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of the Purview account to link to the Data Factory. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the resource will be created. | `string` | n/a | yes |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | A map of role assignments to create on the Data Factory. | <pre>map(object({<br/>    role_definition_id_or_name             = string<br/>    principal_id                           = string<br/>    description                            = optional(string, null)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    condition                              = optional(string, null)<br/>    condition_version                      = optional(string, null)<br/>    delegated_managed_identity_resource_id = optional(string, null)<br/>    principal_type                         = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `null` | no |
| <a name="input_vsts_configuration"></a> [vsts\_configuration](#input\_vsts\_configuration) | VCS configuration for Azure DevOps (VSTS). | <pre>object({<br/>    account_name       = string<br/>    branch_name        = string<br/>    project_name       = string<br/>    repository_name    = string<br/>    root_folder        = string<br/>    tenant_id          = string<br/>    publishing_enabled = optional(bool, true)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | The name of the Data Factory resource |
| <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints) | A map of private endpoints. The map key is the supplied input to var.private\_endpoints. The map value is the entire azurerm\_private\_endpoint resource. |
| <a name="output_resource"></a> [resource](#output\_resource) | This is the full output for the resource. |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The resource id of the Data Factory resource. |
<!-- END_TF_DOCS -->