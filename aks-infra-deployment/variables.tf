# Root module - variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "aks-resource-group"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Production"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "AKS Deployment"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnet names to address prefixes"
  type        = map(list(string))
  default = {
    "aks-subnet" = ["10.0.1.0/24"]
  }
}

variable "sp_display_name" {
  description = "Display name for the service principal"
  type        = string
  default     = "aks-service-prin"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "my-aks-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "myakscluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use"
  type        = string
  default     = "1.27.7"
}

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default"
}

variable "default_node_pool_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "default_node_pool_vm_size" {
  description = "VM size for the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "default_node_pool_enable_auto_scaling" {
  description = "Enable auto scaling for the default node pool"
  type        = bool
  default     = true
}

variable "default_node_pool_min_count" {
  description = "Minimum number of nodes for the default node pool"
  type        = number
  default     = 1
}

variable "default_node_pool_max_count" {
  description = "Maximum number of nodes for the default node pool"
  type        = number
  default     = 3
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

variable "network_plugin" {
  description = "Network plugin to use for the AKS cluster"
  type        = string
  default     = "azure"
}

variable "network_policy" {
  description = "Network policy to use for the AKS cluster"
  type        = string
  default     = "calico"
}

variable "dns_service_ip" {
  description = "DNS service IP"
  type        = string
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "Docker bridge CIDR"
  type        = string
  default     = "172.17.0.1/16"
}

variable "service_cidr" {
  description = "Service CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "role_based_access_control_enabled" {
  description = "Enable RBAC on the cluster"
  type        = bool
  default     = true
}


### Azure container registry configuration variables

# Root module - variables.tf (additions)
variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "myaksacr"
}

variable "acr_sku" {
  description = "The SKU of the container registry (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Enable admin user for the container registry"
  type        = bool
  default     = false
}

variable "acr_georeplications" {
  description = "List of locations for geo-replication (Premium SKU only)"
  type = list(object({
    location                = string
    zone_redundancy_enabled = bool
    tags                    = map(string)
  }))
  default = []
}

variable "acr_network_rule_set" {
  description = "Network rules for the container registry (Premium SKU only)"
  type = object({
    default_action         = string
    ip_rules               = list(string)
    virtual_network_rules  = list(string)
  })
  default = null
}

variable "acr_public_network_access_enabled" {
  description = "Enable public network access for the container registry"
  type        = bool
  default     = true
}

variable "acr_zone_redundancy_enabled" {
  description = "Enable zone redundancy for the container registry"
  type        = bool
  default     = false
}