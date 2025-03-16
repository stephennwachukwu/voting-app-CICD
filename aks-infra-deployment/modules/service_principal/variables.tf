# modules/service_principal/variables.tf
variable "azure_service_principal_display_name" {
  description = "A display name for the <entra-service-principal>."
  type        = string
}

variable "time_rotating" {
  description = "Number of days to rotate the credential in months"
  type        = number
  default     = 30
}
