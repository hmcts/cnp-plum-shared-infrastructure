import {
  to = azurerm_key_vault_secret.appInsights-InstrumentationKey
  id = "crumblesi-sandbox/appInsights-InstrumentationKey"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.developer[0]
  id = "crumblesi-sandbox/objectId/b2a1773c-a5ae-48b5-b5fa-95b0e05eee05"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.creator_access_policy
  id = "crumblesi-sandbox/objectId/0292f26e-288e-4f5b-85fc-b99a53f0a2b1"
}

import {
  to = module.vault.azurerm_key_vault_access_policy.product_team_access_policy
  id = "crumblesi-sandbox/objectId/e7ea2042-4ced-45dd-8ae3-e051c6551789"
}

import {
  to = module.vault.azurerm_monitor_diagnostic_setting.kv-ds
  id = "kv-ds|/subscriptions/bf308a5c-0624-4334-8ff8-8dca9fd43783/resourceGroups/crumble-shared-infrastructure-sandbox/providers/Microsoft.KeyVault/vaults/crumblesi-sandbox"
}
