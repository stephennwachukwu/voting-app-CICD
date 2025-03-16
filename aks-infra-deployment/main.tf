# Root module - main.tf
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "azuread" {}

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = local.common_tags
}

module "networking" {
  source              = "./modules/networking"
  vnet_name           = var.vnet_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.common_tags
}

module "service_principal" {
  source       = "./modules/service_principal"
  display_name = var.sp_display_name
}

module "aks_cluster" {
  source              = "./modules/aks_cluster"
  cluster_name        = var.cluster_name
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool = {
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_count
    vm_size             = var.default_node_pool_vm_size
    vnet_subnet_id      = module.networking.subnet_ids["aks-subnet"]
    enable_auto_scaling = var.default_node_pool_enable_auto_scaling
    min_count           = var.default_node_pool_min_count
    max_count           = var.default_node_pool_max_count
  }

  additional_node_pools = var.additional_node_pools

  use_managed_identity = var.use_managed_identity
  client_id            = var.use_managed_identity ? "" : module.service_principal.client_id
  client_secret        = var.use_managed_identity ? "" : module.service_principal.client_secret

  attached_acr_id = module.container_registry.registry_id

  network_profile = {
    network_plugin     = var.network_plugin
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    service_cidr       = var.service_cidr
  }

  role_based_access_control_enabled = var.role_based_access_control_enabled
  tags                              = local.common_tags

  # This order ensures that the ACR exists before AKS tries to integrate with it.
  depends_on = [module.container_registry]
}

module "container_registry" {
  source              = "./modules/container_registry"
  registry_name       = var.acr_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled
  georeplications     = var.acr_georeplications
  network_rule_set    = var.acr_network_rule_set
  
  # Advanced features
  public_network_access_enabled = var.acr_public_network_access_enabled
  zone_redundancy_enabled       = var.acr_zone_redundancy_enabled
  
  # Integration with AKS
  assign_aks_acr_pull_role = true
  aks_principal_id         = var.use_managed_identity ? module.aks_cluster.cluster_identity_principal_id : module.service_principal.service_principal_id
  
  tags = local.common_tags
}