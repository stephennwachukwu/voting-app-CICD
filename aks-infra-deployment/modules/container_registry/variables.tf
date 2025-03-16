# modules/container_registry/variables.tf
variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "sku" {
  description = "The SKU of the container registry (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The container registry SKU must be one of: Basic, Standard, Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user for the container registry"
  type        = bool
  default     = false
}

variable "georeplications" {
  description = "List of locations for geo-replication (Premium SKU only)"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
    tags                    = map(string)
  }))
  default = []
}

variable "network_rule_set" {
  description = "Network rules for the container registry (Premium SKU only)"
  type = object({
    default_action         = string
    ip_rules               = list(string)
    virtual_network_rules  = list(string)
  })
  default = null
}

variable "identity_type" {
  description = "The type of identity to use (SystemAssigned, UserAssigned, SystemAssigned, UserAssigned)"
  type        = string
  default     = "SystemAssigned"
}

variable "encryption_enabled" {
  description = "Enable encryption for the container registry"
  type        = bool
  default     = false
}

variable "encryption_key_vault_key_id" {
  description = "The ID of the Key Vault key to use for encryption"
  type        = string
  default     = null
}

variable "encryption_identity_client_id" {
  description = "The client ID of the identity to use for encryption"
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Enable public network access for the container registry"
  type        = bool
  default     = true
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy for the container registry"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "assign_aks_acr_pull_role" {
  description = "Assign AcrPull role to AKS service principal or managed identity"
  type        = bool
  default     = true
}

variable "aks_principal_id" {
  description = "The principal ID of the AKS service principal or managed identity"
  type        = string
  default     = ""
}

# for private endpoint for the ACR
variable "create_private_endpoint" {
  description = "Create a private endpoint for ACR"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet for the private endpoint"
  type        = string
  default     = ""
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone for the private endpoint"
  type        = string
  default     = ""
}