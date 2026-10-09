data "azurerm_subnet" "speech_storage_private_endpoint" {
  count    = var.env == "sandbox" ? 1 : 0
  provider = azurerm.private_endpoint

  name                 = "private-endpoints"
  virtual_network_name = local.cft_aks_network_name
  resource_group_name  = local.cft_aks_network_rg_name
}
