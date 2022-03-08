provider "azurerm" {
  alias           = "aks_aat"
  subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
  features {}
}

provider "azurerm" {
  alias                      = "aks-infra"
  skip_provider_registration = true
  subscription_id            = "96c274ce-846d-4e48-89a7-d528432298a7"
  features {}
}

provider "azurerm" {
  alias                      = "mgmt"
  skip_provider_registration = true
  subscription_id            = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
  features {}
}