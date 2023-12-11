import {
  to = azurerm_key_vault_secret.appInsights-InstrumentationKey
  id = "https://plumsi-sandbox.vault.azure.net/secrets/appInsights-InstrumentationKey/fa79e285139143e5a41b5c7014eac8b5"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.developer[0]
  id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/plum-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/plumsi-sandbox/objectId/b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
}

import {
  to = module.vault.azurerm_monitor_diagnostic_setting.kv-ds
  id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/plum-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/plumsi-sandbox|plumsi-sandbox"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.creator_access_policy
  id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/plum-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/plumsi-sandbox/objectId/0292f26e-288e-4f5b-85fc-b99a53f0a2b1"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.managed_identity_access_policy["60ab1441-a8a9-4990-aa30-c94e9f0b047b"]
  id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/plum-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/plumsi-sandbox/objectId/60ab1441-a8a9-4990-aa30-c94e9f0b047b"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.product_team_access_policy
  id = "/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/plum-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/plumsi-sandbox/objectId/e7ea2042-4ced-45dd-8ae3-e051c6551789"
}