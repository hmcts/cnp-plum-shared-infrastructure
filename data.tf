data "azurerm_subnet" "speech_storage_private_endpoint" {
  count    = var.env == "sandbox" ? 1 : 0
  provider = azurerm.private_endpoint

  name                 = "private-endpoints"
  virtual_network_name = local.cft_aks_network_name
  resource_group_name  = local.cft_aks_network_rg_name

  lifecycle {
    postcondition {
      condition     = lower(self.id) == lower("/subscriptions/b72ab7b7-723f-4b18-b6f6-03b0f2c6a1bb/resourceGroups/cft-sbox-network-rg/providers/Microsoft.Network/virtualNetworks/cft-sbox-vnet/subnets/private-endpoints")
      error_message = "Speech Storage must use the supplied CFT sbox private-endpoints subnet; check aks_subscription_id."
    }
  }
}
