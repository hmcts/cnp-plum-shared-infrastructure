data "azurerm_windows_function_app" "alerts" {
  provider            = azurerm.private_endpoint
  name                = "alerts-slack-${var.env}"
  resource_group_name = "alerts-slack-${var.env}"
}

data "azurerm_function_app_host_keys" "host_keys" {
  provider            = azurerm.private_endpoint
  name                = data.azurerm_windows_function_app.alerts.name
  resource_group_name = "alerts-slack-${var.env}"
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "${title(var.product)}-${title(var.env)}-Warning-Alerts"
  resource_group_name = azurerm_resource_group.shared_resource_group.name
  short_name          = "${var.product}-${var.env}"

  azure_function_receiver {
    function_app_resource_id = data.azurerm_windows_function_app.alerts.id
    function_name            = "httpTrigger"
    http_trigger_url         = "https://${data.azurerm_windows_function_app.alerts.default_hostname}/api/httpTrigger?code=${data.azurerm_function_app_host_keys.host_keys.primary_key}"
    name                     = "slack-alerts"
    use_common_alert_schema  = true
  }

  dynamic "email_receiver" {
    for_each = var.email_receiver_config != null ? [var.email_receiver_config] : []
    content {
      name          = email_receiver.value["name"]
      email_address = email_receiver.value["email_address"]
    }
  }

  tags = var.common_tags
} 

module "application_insights" {
  source = "git@github.com:hmcts/terraform-module-application-insights?ref=alert"

  env     = var.env
  product = var.product
  name    = var.product

  resource_group_name = azurerm_resource_group.shared_resource_group.name

  common_tags = var.common_tags

  daily_data_cap_in_gb = var.daily_data_cap_in_gb

  action_group_id = azurerm_monitor_action_group.action_group.id

  additional_action_group_ids = [
    {
      ag_name                = "test-AG"
      ag_short_name          = "otag"
      email_receiver_name    = "bob"
      email_receiver_address = "test@email"
      resourcegroup_name     = azurerm_resource_group.shared_resource_group.name
    }
  ]
}

moved {
  from = azurerm_application_insights.appinsights
  to   = module.application_insights.azurerm_application_insights.this
}

resource "azurerm_key_vault_secret" "appInsights-InstrumentationKey" {
  name         = "appInsights-InstrumentationKey"
  value        = module.application_insights.instrumentation_key
  key_vault_id = module.vault.key_vault_id
}
