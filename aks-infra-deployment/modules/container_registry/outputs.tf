# modules/container_registry/outputs.tf
output "registry_id" {
  description = "The ID of the container registry"
  value       = azurerm_container_registry.acr.id
}

output "registry_name" {
  description = "The name of the container registry"
  value       = azurerm_container_registry.acr.name
}

output "registry_url" {
  description = "The URL of the container registry"
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "The admin username of the container registry"
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_username : null
}

output "admin_password" {
  description = "The admin password of the container registry"
  value       = var.admin_enabled ? azurerm_container_registry.acr.admin_password : null
  sensitive   = true
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned identity"
  value       = azurerm_container_registry.acr.identity.0.principal_id
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned identity"
  value       = azurerm_container_registry.acr.identity.0.tenant_id
}

# Premium SKU with geo-replication, for the replicated registry URLs
output "georeplication_locations" {
  description = "The locations of the geo-replicated registries"
  value       = [for r in azurerm_container_registry.acr.georeplications : r.location]
}