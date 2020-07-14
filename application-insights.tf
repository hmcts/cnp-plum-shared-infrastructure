resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-${var.env}"
  location            = var.appinsights_location
  resource_group_name = azurerm_resource_group.shared_resource_group.name
  application_type    = var.application_type
}

output "appInsightsInstrumentationKey" {
  value = azurerm_application_insights.appinsights.instrumentation_key
}

resource "azurerm_key_vault_secret" "appInsights-InstrumentationKey" {
  name      = "appInsights-InstrumentationKey"
  value     = azurerm_application_insights.appinsights.instrumentation_key
  key_vault_id = module.vault.key_vault_id
}