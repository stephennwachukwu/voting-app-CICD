# modules/resource_group/main.tf
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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}