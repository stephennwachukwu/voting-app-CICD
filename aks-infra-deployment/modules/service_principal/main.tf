# modules/service_principal/main.tf
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

resource "azuread_application" "this" {
  display_name = var.azure_service_principal_display_name
}

resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}

# resource "random_password" "password" {
#   length  = var.password_length
#   special = true
# }

resource "time_rotating" "month" {
  rotation_days = var.time_rotating
}

resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.object_id
  rotate_when_changed  = { rotation = time_rotating.month.id }
}