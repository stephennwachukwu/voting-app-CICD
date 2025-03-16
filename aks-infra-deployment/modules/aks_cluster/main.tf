# modules/aks_cluster/main.tf
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

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    vnet_subnet_id      = var.default_node_pool.vnet_subnet_id
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.min_count
    max_count           = var.default_node_pool.max_count
  }

  dynamic "service_principal" {
    for_each = var.use_managed_identity ? [] : [1]
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  dynamic "identity" {
    for_each = var.use_managed_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "attach_acr" {
    for_each = var.attached_acr_id != "" ? [1] : []
    content {
      acr_id = var.attached_acr_id
    }
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    service_cidr       = var.network_profile.service_cidr
  }

  role_based_access_control_enabled = var.role_based_access_control_enabled

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_pools" {
  for_each              = var.additional_node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  enable_auto_scaling = try(each.value.enable_auto_scaling, null)
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  vnet_subnet_id        = each.value.vnet_subnet_id
  tags                  = each.value.tags
}