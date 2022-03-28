terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.97.0"
    }
    random = {
      source = "hashicorp/random"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 1.6.0"
    }
  }
}

