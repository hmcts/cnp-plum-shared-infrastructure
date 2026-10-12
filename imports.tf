import {
  for_each = var.env == "sandbox" ? { jenkins_ptl = true } : {}

  to = module.vault.azurerm_key_vault_access_policy.jenkins_ptl[0]
  id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/plum-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/plumsi-sandbox/objectId/0292f26e-288e-4f5b-85fc-b99a53f0a2b1"
}
