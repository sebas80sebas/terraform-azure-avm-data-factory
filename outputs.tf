output "name" {
  description = "The name of the Data Factory resource"
  value       = module.datafactory.name
}

output "private_endpoints" {
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
  value       = module.datafactory.private_endpoints
}

output "resource" {
  description = "This is the full output for the resource."
  value       = module.datafactory.resource
}

output "resource_id" {
  description = "The resource id of the Data Factory resource."
  value       = module.datafactory.resource_id
}
