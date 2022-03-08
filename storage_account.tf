# locals {
#   storage_account_name      = "${var.product}shared${var.env}"
#   mgmt_network_name         = "cft-ptl-vnet"
#   mgmt_network_rg_name      = "cft-ptl-network-rg"

#   aat_cft_vnet_name           = "cft-aat-vnet"
#   aat_cft_vnet_resource_group = "cft-aat-network-rg"

#   vnet_name = var.env == "sbox" || var.env == "perftest" || var.env == "ithc" || var.env == "preview" ? "cft-${var.env}-vnet" : "core-${var.env}-vnet"
#   vnet_resource_group_name = var.env == "sbox" || var.env == "perftest" || var.env == "ithc" || var.env == "preview" ? "cft-${var.env}-network-rg" : "aks-infra-${var.env}-rg"

#   # standard_subnets = [
#   #   data.azurerm_subnet.jenkins_subnet.id,
#   #   data.azurerm_subnet.aks-00-mgmt.id,
#   #   data.azurerm_subnet.aks-01-mgmt.id,
#   #   data.azurerm_subnet.aks-00-infra.id,
#   #   data.azurerm_subnet.aks-01-infra.id]

#   # preview_subnets  = var.env == "prod" ? [data.azurerm_subnet.aks-00-preview.id, data.azurerm_subnet.aks-00-preview.id] : []
#   # cft_aat_subnets = var.env == "aat" ? [data.azurerm_subnet.aat_aks_00_subnet.id, data.azurerm_subnet.aat_aks_01_subnet.id, data.azurerm_subnet.aks-00-preview.id, data.azurerm_subnet.aks-00-preview.id] : []
#   # sa_subnets    = concat(local.standard_subnets, local.preview_subnets, local.cft_aat_subnets)

# }

# # data "azurerm_subnet" "aat_aks_00_subnet" {
# #   provider             = azurerm.aks-aat
# #   name                 = "aks-00"
# #   virtual_network_name = local.aat_cft_vnet_name
# #   resource_group_name  = local.aat_cft_vnet_resource_group
# # }

# # data "azurerm_subnet" "aat_aks_01_subnet" {
# #   provider             = azurerm.aks-aat
# #   name                 = "aks-01"
# #   virtual_network_name = local.aat_cft_vnet_name
# #   resource_group_name  = local.aat_cft_vnet_resource_group
# # }

# # data "azurerm_virtual_network" "mgmt_vnet" {
# #   provider            = azurerm.mgmt
# #   name                = local.mgmt_network_name
# #   resource_group_name = local.mgmt_network_rg_name
# # }

# # data "azurerm_subnet" "jenkins_subnet" {
# #   provider             = azurerm.mgmt
# #   name                 = "iaas"
# #   virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
# # }

# # data "azurerm_subnet" "aks-00-mgmt" {
# #   provider             = azurerm.mgmt
# #   name                 = "aks-00"
# #   virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
# # }

# # data "azurerm_subnet" "aks-01-mgmt" {
# #   provider             = azurerm.mgmt
# #   name                 = "aks-01"
# #   virtual_network_name = data.azurerm_virtual_network.mgmt_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.mgmt_vnet.resource_group_name
# # }

# # data "azurerm_virtual_network" "aks_core_vnet" {
# #   provider            = azurerm.aks-infra
# #   name                = local.vnet_name
# #   resource_group_name = local.vnet_resource_group_name
# # }

# # data "azurerm_subnet" "aks-00-infra" {
# #   provider             = azurerm.aks-infra
# #   name                 = "aks-00"
# #   virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
# # }

# # data "azurerm_subnet" "aks-01-infra" {
# #   provider             = azurerm.aks-infra
# #   name                 = "aks-01"
# #   virtual_network_name = data.azurerm_virtual_network.aks_core_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.aks_core_vnet.resource_group_name
# # }

# # data "azurerm_virtual_network" "aks_preview_vnet" {
# #   provider            = azurerm.aks-preview
# #   name                = "cft-preview-vnet"
# #   resource_group_name = "cft-preview-network-rg"
# # }

# # data "azurerm_subnet" "aks-00-preview" {
# #   provider             = azurerm.aks-preview
# #   name                 = "aks-00"
# #   virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
# # }

# # data "azurerm_subnet" "aks-01-preview" {
# #   provider             = azurerm.aks-preview
# #   name                 = "aks-01"
# #   virtual_network_name = data.azurerm_virtual_network.aks_preview_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.aks_preview_vnet.resource_group_name
# # }

# # data "azurerm_virtual_network" "aks_prod_vnet" {
# #   provider            = azurerm.aks-prod
# #   name                = "cft-prod-vnet"
# #   resource_group_name = "cft-prod-network-rg"
# # }

# # data "azurerm_subnet" "aks-00-prod" {
# #   provider             = azurerm.aks-prod
# #   name                 = "aks-00"
# #   virtual_network_name = data.azurerm_virtual_network.aks_prod_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.aks_prod_vnet.resource_group_name
# # }

# # data "azurerm_subnet" "aks-01-prod" {
# #   provider             = azurerm.aks-prod
# #   name                 = "aks-01"
# #   virtual_network_name = data.azurerm_virtual_network.aks_prod_vnet.name
# #   resource_group_name  = data.azurerm_virtual_network.aks_prod_vnet.resource_group_name
# # }

# provider "azurerm" {
#   alias           = "aks-infra"
#   subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
#   features {}
#   skip_provider_registration = true
# }

# provider "azurerm" {
#   alias           = "aks-preview"
#   subscription_id = "8b6ea922-0862-443e-af15-6056e1c9b9a4"
#   features {}
# }

# provider "azurerm" {
#   alias           = "mgmt"
#   subscription_id = var.mgmt_subscription_id
#   features {}
# }

# provider "azurerm" {
#   alias           = "aks-prod"
#   subscription_id = "8cbc6f36-7c56-4963-9d36-739db5d00b27"
#   features {}
# }

# provider "azurerm" {
#   alias           = "aks-aat"
#   subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
#   features {}
# }

# provider "azurerm" {
#   alias           = "aks_aat"
#   subscription_id = "96c274ce-846d-4e48-89a7-d528432298a7"
#   features {}
# }

# variable "mgmt_subscription_id" {}

# variable "aks_infra_subscription_id" {}

# variable "aks_preview_subscription_id" {}