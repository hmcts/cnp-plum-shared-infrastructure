locals {
  mgmt_network_name     = "core-cftptl-intsvc-vnet"
  mgmt_network_rg_name  = "aks-infra-cftptl-intsvc-rg"

  aat_vnet_name           = "cft-aat-vnet"
  aat_vnet_resource_group = "cft-aat-network-rg"

  aks_core_vnet = var.env == "preview" ? join("-", ["cft", var.env, "vnet"]) : join("-", ["core", var.env, "vnet"])
  aks_core_vnet_rg = var.env == "preview" ? join("-", ["cft", var.env, "network-rg"]) : join("-", ["aks-infra", var.env, "rg"])

  sa_aat_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.aks-00-mgmt.id,
    data.azurerm_subnet.aks-01-mgmt.id,
    data.azurerm_subnet.aks-00-infra.id,
    data.azurerm_subnet.aks-01-infra.id,
    data.azurerm_subnet.aks-00-aat.id,
    data.azurerm_subnet.aks-01-aat.id]

  sa_prod_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.aks-00-mgmt.id,
    data.azurerm_subnet.aks-01-mgmt.id,
    data.azurerm_subnet.aks-00-infra.id,
    data.azurerm_subnet.aks-01-infra.id,
    data.azurerm_subnet.aks-00-prod.id,
    data.azurerm_subnet.aks-01-prod.id]

  sa_other_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.aks-00-mgmt.id,
    data.azurerm_subnet.aks-01-mgmt.id,
    data.azurerm_subnet.aks-00-infra.id,
    data.azurerm_subnet.aks-01-infra.id]

  sa_subnets = split(",", var.env == "aat" ? join(",", local.sa_aat_subnets) : join(",", local.sa_other_subnets) || var.env == "aat" ? join(",", local.sa_aat_subnets): join(",", local.sa_other_subnets))
}

provider "azurerm" {
  alias           = "aks_aat"
  subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
  features {}
}

provider "azurerm" {
  alias           = "aks-prod"
  subscription_id = "8cbc6f36-7c56-4963-9d36-739db5d00b27"
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

data "azurerm_virtual_network" "aks_prod_vnet" {
  provider            = azurerm.aks-prod
  name                = "cft-prod-vnet"
  resource_group_name = "cft-prod-network-rg"
}

data "azurerm_subnet" "aks-00-prod" {
  provider             = azurerm.aks-prod
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_prod_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_prod_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-prod" {
  provider             = azurerm.aks-prod
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_prod_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_prod_vnet.resource_group_name
}

data "azurerm_subnet" "aat_aks_00_subnet" {
  provider             = azurerm.aks_aat
  name                 = "aks-00"
  virtual_network_name = local.aat_vnet_name
  resource_group_name  = local.aat_vnet_resource_group
}

data "azurerm_subnet" "aat_aks_01_subnet" {
  provider             = azurerm.aks_aat
  name                 = "aks-01"
  virtual_network_name = local.aat_vnet_name
  resource_group_name  = local.aat_vnet_resource_group
}

data "azurerm_virtual_network" "mgmt_vnet" {
  provider            = azurerm.mgmt
  name                = local.mgmt_network_name
  resource_group_name = local.mgmt_network_rg_name
}

data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_core_vnet" {
  provider            = azurerm.aks-infra
  name                = local.aks_core_vnet
  resource_group_name = local.aks_core_vnet_rg
}

data "azurerm_subnet" "aks_00" {
  provider             = azurerm.aks-infra
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_subnet" "aks_01" {
  provider             = azurerm.aks-infra
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

module "storage_account" {
  source                   = "git@github.com:hmcts/cnp-module-storage-account?ref=master"
  env                      = var.env
  storage_account_name     = "plumtestaat"
  resource_group_name      = azurerm_resource_group.shared_resource_group.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
  enable_https_traffic_only = true

  // Tags
  common_tags  = local.tags

  sa_subnets = local.all_valid_subnets

}