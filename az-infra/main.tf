# =========================================================================
# Terraform and Azure RM provider block and resource group
# =========================================================================
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfmstaterg"
    storage_account_name = "zcit2k24tfmwappsacc"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}rg"
  location = var.rg_location
}
# =========================================================================