# modules/service_principal/outputs.tf
output "application_id" {
  value = azuread_application.this.application_id
}

output "azure_client_id" {
  description = "The Azure AD service principal's application (client) ID."
  value       = azuread_application.this.application_id
}

output "azure_client_secret" {
  description = "The Azure AD service principal's client secret value."
  value       = azuread_service_principal_password.this.value
  sensitive   = true
}

output "service_principal_id" {
  value = azuread_service_principal.this.id
}