module "datafactory" {
  source  = "Azure/avm-res-datafactory-factory/azurerm"
  version = "0.1.0"

  # Required Variables
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Optional Variables
  credential_service_principal            = var.credential_service_principal
  credential_user_managed_identity        = var.credential_user_managed_identity
  customer_managed_key_id                 = var.customer_managed_key_id
  customer_managed_key_identity_id        = var.customer_managed_key_identity_id
  diagnostic_settings                     = var.diagnostic_settings
  enable_telemetry                        = var.enable_telemetry
  github_configuration                    = var.github_configuration
  global_parameters                       = var.global_parameters
  integration_runtime_self_hosted         = var.integration_runtime_self_hosted
  linked_service_azure_blob_storage       = var.linked_service_azure_blob_storage
  linked_service_azure_file_storage       = var.linked_service_azure_file_storage
  linked_service_azure_sql_database       = var.linked_service_azure_sql_database
  linked_service_data_lake_storage_gen2   = var.linked_service_data_lake_storage_gen2
  linked_service_databricks               = var.linked_service_databricks
  linked_service_key_vault                = var.linked_service_key_vault
  lock                                    = var.lock
  managed_identities                      = var.managed_identities
  managed_virtual_network_enabled         = var.managed_virtual_network_enabled
  private_endpoints                       = var.private_endpoints
  private_endpoints_manage_dns_zone_group = var.private_endpoints_manage_dns_zone_group
  public_network_enabled                  = var.public_network_enabled
  purview_id                              = var.purview_id
  role_assignments                        = var.role_assignments
  tags                                    = var.tags
  vsts_configuration                      = var.vsts_configuration
}
