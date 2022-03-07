locals {
  mgmt_network_name     = "core-cftptl-intsvc-vnet"
  mgmt_network_rg_name  = "aks-infra-cftptl-intsvc-rg"

  aat_vnet_name           = "cft-aat-vnet"
  aat_vnet_resource_group = "cft-aat-network-rg"

  aks_core_vnet = var.env == "preview" ? join("-", ["cft", var.env, "vnet"]) : join("-", ["core", var.env, "vnet"])
  aks_core_vnet_rg = var.env == "preview" ? join("-", ["cft", var.env, "network-rg"]) : join("-", ["aks-infra", var.env, "rg"])

  valid_subnets = [
    data.azurerm_subnet.aks_00.id,
    data.azurerm_subnet.aks_01.id,
    data.azurerm_subnet.jenkins_subnet.id,
  ]

  cft_prod_subnets = var.env == "aat" ? [data.azurerm_subnet.aat_aks_00_subnet.id, data.azurerm_subnet.aat_aks_01_subnet.id] : []

  all_valid_subnets = concat(local.valid_subnets, local.cft_aat_subnets)
}

provider "azurerm" {
  alias           = "aks_aat"
  subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
  features {}
}

provider "azurerm" {
  alias                      = "aks-infra"
  skip_provider_registration = true
  subscription_id            = var.aks_infra_subscription_id
  features {}
}

provider "azurerm" {
  alias                      = "mgmt"
  skip_provider_registration = true
  subscription_id            = var.jenkins_subscription_id
  features {}
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
  storage_account_name     = local.account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  //  enable_blob_encryption    = true
  //  enable_file_encryption    = true
  enable_https_traffic_only = true

  // Tags
  common_tags  = local.tags
  team_contact = var.team_contact
  destroy_me   = var.destroy_me

  sa_subnets = local.all_valid_subnets

}