terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
    random = {
      source = "hashicorp/random"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private_endpoint"
  subscription_id            = var.aks_subscription_id
}
