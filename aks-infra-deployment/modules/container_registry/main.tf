# modules/container_registry/main.tf
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
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  
  # Conditional geo-replication for Premium SKU
  dynamic "georeplications" {
    for_each = var.sku == "Premium" && length(var.georeplications) > 0 ? var.georeplications : []
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = georeplications.value.tags
    }
  }
  
  # Network rule set for Premium SKU
  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" && var.network_rule_set != null ? [var.network_rule_set] : []
    content {
      default_action = network_rule_set.value.default_action
      
      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rules != null ? network_rule_set.value.ip_rules : []
        content {
          action   = "Allow"
          ip_range = ip_rule.value
        }
      }
      
      dynamic "virtual_network" {
        for_each = network_rule_set.value.virtual_network_rules != null ? network_rule_set.value.virtual_network_rules : []
        content {
          action    = "Allow"
          subnet_id = virtual_network.value
        }
      }
    }
  }
  
  # Advanced features
  identity {
    type = var.identity_type
  }
  
  encryption {
    enabled            = var.encryption_enabled
    key_vault_key_id   = var.encryption_key_vault_key_id
    identity_client_id = var.encryption_identity_client_id
  }
  
  # Enable features based on SKU
  public_network_access_enabled = var.public_network_access_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  
  tags = var.tags
}

# Create role assignment for AKS to ACR
resource "azurerm_role_assignment" "acr_pull" {
  count                = var.assign_aks_acr_pull_role && var.aks_principal_id != "" ? 1 : 0
  principal_id         = var.aks_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

# Adding a private endpoint for ACR
resource "azurerm_private_endpoint" "acr_pe" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "${var.container_registry_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.container_registry_name}-psc"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = var.tags
}