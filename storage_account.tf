locals {
  storage_account_name      = "${var.product}shared${var.env}"
  mgmt_network_name         = "cft-ptl-vnet"
  mgmt_network_rg_name      = "cft-ptl-network-rg"

  aat_cft_vnet_name           = "cft-aat-vnet"
  aat_cft_vnet_resource_group = "cft-aat-network-rg"

  vnet_name = var.env == "sbox" || var.env == "perftest" || var.env == "ithc" || var.env == "preview" ? "cft-${var.env}-vnet" : "core-${var.env}-vnet"
  vnet_resource_group_name = var.env == "sbox" || var.env == "perftest" || var.env == "ithc" || var.env == "preview" ? "cft-${var.env}-network-rg" : "aks-infra-${var.env}-rg"

  standard_subnets = [
    data.azurerm_subnet.jenkins_subnet.id,
    data.azurerm_subnet.aks-00-mgmt.id,
    data.azurerm_subnet.aks-01-mgmt.id,
    data.azurerm_subnet.aks-00-infra.id,
    data.azurerm_subnet.aks-01-infra.id]

  preview_subnets  = var.env == "prod" ? [data.azurerm_subnet.aks-00-preview.id.id, data.azurerm_subnet.aks-00-preview.id.id] : []
  cft_aat_subnets = var.env == "aat" ? [data.azurerm_subnet.aat_aks_00_subnet.id, data.azurerm_subnet.aat_aks_01_subnet.id, data.azurerm_subnet.aks-00-preview.id.id, data.azurerm_subnet.aks-00-preview.id.id] : []
  sa_subnets    = concat(local.standard_subnets, local.preview_subnets, local.cft_aat_subnets)

}

// pcq blob Storage Account
module "pcq_storage_account" {
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

  // enable_blob_encryption    = true
  // enable_file_encryption    = true
  // Tags
  common_tags               = var.common_tags

  sa_subnets = local.sa_subnets
}
////////////////////////////////////////////////

data "azurerm_subnet" "aat_aks_00_subnet" {
  provider             = azurerm.aks-prod
  name                 = "aks-00"
  virtual_network_name = local.aat_cft_vnet_name
  resource_group_name  = local.aat_cft_vnet_resource_group
}

data "azurerm_subnet" "aat_aks_01_subnet" {
  provider             = azurerm.aks-prod
  name                 = "aks-01"
  virtual_network_name = local.aat_cft_vnet_name
  resource_group_name  = local.aat_cft_vnet_resource_group
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

data "azurerm_subnet" "aks-00-mgmt" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-mgmt" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
  resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_core_vnet" {
  provider            = azurerm.aks-infra
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "aks-00-infra" {
  provider             = azurerm.aks-infra
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-infra" {
  provider             = azurerm.aks-infra
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
}

data "azurerm_virtual_network" "aks_preview_vnet" {
  provider            = azurerm.aks-preview
  name                = "cft-preview-vnet"
  resource_group_name = "cft-preview-network-rg"
}

data "azurerm_subnet" "aks-00-preview" {
  provider             = azurerm.aks-preview
  name                 = "aks-00"
  virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
}

data "azurerm_subnet" "aks-01-preview" {
  provider             = azurerm.aks-preview
  name                 = "aks-01"
  virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
  resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
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