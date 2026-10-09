locals {
  aks_env                 = var.env == "sandbox" ? "sbox" : var.env
  cft_aks_network_name    = "cft-${local.aks_env}-vnet"
  cft_aks_network_rg_name = "cft-${local.aks_env}-network-rg"
}
