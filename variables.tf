variable "credential_service_principal" {
  type = map(object({
    name = string
    data_factory_id = optional(string)
    tenant_id = string
    service_principal_id = string
    annotations = optional(list(string), null)
    description = optional(string, null)
    service_principal_key = optional(object({
      linked_service_name = string
      secret_name = string
      secret_version = optional(string, null)
    }), null)
  }))
  default     = {}
  description = "A map of service principal credentials to create."
}

variable "credential_user_managed_identity" {
  type = map(object({
    name = string
    data_factory_id = optional(string)
    identity_id = string
    annotations = optional(list(string), null)
    description = optional(string, null)
  }))
  default     = {}
  description = "A map of user managed identity credentials to create."
}

variable "customer_managed_key_id" {
  type        = string
  default     = null
  description = "The ID of the Key Vault Key to use for Customer Managed Keys."
}

variable "customer_managed_key_identity_id" {
  type        = string
  default     = null
  description = "The ID of the User Assigned Identity to use for Customer Managed Keys."
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = "A map of diagnostic settings to create."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = "Controls whether telemetry is enabled for the module."
}

variable "github_configuration" {
  type = object({
    account_name       = string
    branch_name        = string
    git_url            = optional(string, null)
    repository_name    = string
    root_folder        = string
    publishing_enabled = optional(bool, true)
  })
  default     = null
  description = "VCS configuration for GitHub."
}

variable "global_parameters" {
  type = list(object({
    name  = string
    type  = string
    value = any
  }))
  default     = []
  description = "List of global parameters to define in the Data Factory."
}

variable "integration_runtime_self_hosted" {
  type = map(object({
    data_factory_id                              = optional(string)
    name                                         = string
    description                                  = optional(string, null)
    self_contained_interactive_authoring_enabled = optional(bool, null)
    rbac_authorization = optional(object({
      resource_id = string
    }), null)
  }))
  default     = {}
  description = "A map of self-hosted integration runtimes to create."
}

variable "linked_service_azure_blob_storage" {
  type = map(object({
    name                       = string
    description                = optional(string, null)
    integration_runtime_name   = optional(string, null)
    annotations                = optional(list(string), null)
    parameters                 = optional(map(string), null)
    additional_properties      = optional(map(string), null)
    connection_string          = optional(string, null)
    connection_string_insecure = optional(string, null)
    sas_uri                    = optional(string, null)
    service_endpoint           = optional(string, null)
    use_managed_identity       = optional(bool, null)
    service_principal_id       = optional(string, null)
    service_principal_key      = optional(string, null)
    storage_kind               = optional(string, null)
    tenant_id                  = optional(string, null)
    key_vault_sas_token = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
    service_principal_linked_key_vault_key = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
  }))
  default     = {}
  description = "A map of Azure Blob Storage linked services to create."
}

variable "linked_service_azure_file_storage" {
  type = map(object({
    name                     = string
    data_factory_id          = optional(string)
    description              = optional(string, null)
    host                     = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    password                 = optional(string, null)
    user_id                  = optional(string, null)
    additional_properties    = optional(map(string), null)
    connection_string        = string
    file_share               = optional(string, null)
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
  }))
  default     = {}
  description = "A map of Azure File Storage linked services to create."
}

variable "linked_service_azure_sql_database" {
  type = map(object({
    name                     = string
    data_factory_id          = optional(string)
    connection_string        = optional(string, null)
    use_managed_identity     = optional(bool, null)
    service_principal_id     = optional(string, null)
    service_principal_key    = optional(string, null)
    tenant_id                = optional(string, null)
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    additional_properties    = optional(map(string), null)
    credential_name          = optional(string, null)
    key_vault_connection_string = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
  }))
  default     = {}
  description = "A map of Azure SQL Database linked services to create."
}

variable "linked_service_data_lake_storage_gen2" {
  type = map(object({
    name                   = string
    data_factory_id        = optional(string)
    description            = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations            = optional(list(string), null)
    parameters             = optional(map(string), null)
    additional_properties  = optional(map(string), null)
    url                    = string
    storage_account_key    = optional(string, null)
    use_managed_identity   = optional(bool, null)
    service_principal_id   = optional(string, null)
    service_principal_key  = optional(string, null)
    tenant                 = optional(string, null)
  }))
  default     = {}
  description = "A map of Data Lake Storage Gen2 linked services to create."
}

variable "linked_service_databricks" {
  type = map(object({
    adb_domain               = string
    data_factory_id          = optional(string)
    name                     = string
    additional_properties    = optional(map(string), null)
    annotations              = optional(list(string), null)
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    parameters               = optional(map(string), null)
    access_token             = optional(string, null)
    msi_work_space_resource_id = optional(string, null)
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
    existing_cluster_id      = optional(string, null)
    instance_pool = optional(object({
      instance_pool_id      = string
      cluster_version       = string
      min_number_of_workers = optional(number, 1)
      max_number_of_workers = optional(number, null)
    }), null)
    new_cluster_config = optional(object({
      cluster_version       = string
      node_type             = string
      driver_node_type      = optional(string, null)
      max_number_of_workers = optional(number, null)
      min_number_of_workers = optional(number, 1)
      spark_config          = optional(map(string), null)
      spark_environment_variables = optional(map(string), null)
      custom_tags           = optional(map(string), null)
      init_scripts          = optional(list(string), null)
      log_destination       = optional(string, null)
    }), null)
  }))
  default     = {}
  description = "A map of Azure Databricks linked services to create."
}

variable "linked_service_key_vault" {
  type = map(object({
    name                     = string
    data_factory_id          = optional(string)
    key_vault_id             = string
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    additional_properties    = optional(map(string), null)
  }))
  default     = {}
  description = "A map of Key Vault linked services to create."
}

variable "location" {
  type        = string
  description = "The Azure region where the resource exists."
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = "The Resource Lock configuration."
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = "Managed identities configuration."
}

variable "managed_virtual_network_enabled" {
  type        = bool
  default     = false
  description = "Is Managed Virtual Network enabled?"
}

variable "name" {
  type        = string
  description = "The name of the Data Factory."
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
  default     = {}
  description = "A map of private endpoints to create."
}

variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage the DNS zone group for private endpoints."
}

variable "public_network_enabled" {
  type        = bool
  default     = false
  description = "Is the Data Factory visible to the public network?"
}

variable "purview_id" {
  type        = string
  default     = null
  description = "The ID of the Purview account to link to the Data Factory."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the resource will be created."
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = "A map of role assignments to create on the Data Factory."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to the resource."
}

variable "vsts_configuration" {
  type = object({
    account_name       = string
    branch_name        = string
    project_name       = string
    repository_name    = string
    root_folder        = string
    tenant_id          = string
    publishing_enabled = optional(bool, true)
  })
  default     = null
  description = "VCS configuration for Azure DevOps (VSTS)."
}
