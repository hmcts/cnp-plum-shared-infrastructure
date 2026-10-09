locals {
  aks_env                 = var.env == "sandbox" ? "sbox" : var.env
  cft_aks_network_name    = "cft-${local.aks_env}-vnet"
  cft_aks_network_rg_name = "cft-${local.aks_env}-network-rg"

  speech_storage_subnets = concat(
    [for subnet in data.azurerm_subnet.cft_aks : subnet.id],
    [for subnet in data.azurerm_subnet.jenkins : subnet.id],
  )
}
