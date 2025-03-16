# modules/aks_cluster/variables.tf
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use"
  type        = string
}

variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name                = string
    node_count          = number
    vm_size             = string
    vnet_subnet_id      = string
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
  })
}

variable "additional_node_pools" {
  description = "Map of additional node pools to create"
  type = map(object({
    vm_size             = string
    node_count          = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    vnet_subnet_id      = string
    tags                = map(string)
  }))
  default = {}
}

variable "use_managed_identity" {
  description = "Use managed identity instead of service principal"
  type        = bool
  default     = false
}

variable "client_id" {
  description = "Client ID of the service principal"
  type        = string
  default     = ""
}

variable "client_secret" {
  description = "Client secret of the service principal"
  type        = string
  default     = ""
  sensitive   = true
}

variable "network_profile" {
  description = "Network profile configuration"
  type = object({
    network_plugin     = string
    network_policy     = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    service_cidr       = string
  })
}

variable "role_based_access_control_enabled" {
  description = "Enable RBAC on the cluster"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# modules/aks_cluster/variables.tf (additions)
# This is just to make sure it exists since we reference it in the output
variable "use_managed_identity" {
  description = "Use managed identity instead of service principal"
  type        = bool
  default     = false
}

variable "attached_acr_id" {
  description = "ID of the ACR to attach to the AKS cluster"
  type        = string
  default     = ""
}