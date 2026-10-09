data "azurerm_subnet" "cft_aks" {
  for_each = var.env == "sandbox" ? toset(["aks-00", "aks-01"]) : toset([])
  provider = azurerm.private_endpoint

  name                 = each.value
  virtual_network_name = local.cft_aks_network_name
  resource_group_name  = local.cft_aks_network_rg_name
}

data "azurerm_subnet" "jenkins" {
  for_each = var.env == "sandbox" ? toset(["iaas", "aks-00", "aks-01"]) : toset([])
  provider = azurerm.mgmt

  name                 = each.value
  virtual_network_name = "cft-ptl-vnet"
  resource_group_name  = "cft-ptl-network-rg"
}
