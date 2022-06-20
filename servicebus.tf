locals {
  env = var.env == "sandbox" ? "sbox" : var.env
  servicebus_namespace_name = "${var.product}-servicebus-${local.env}"
}

module "servicebus-namespace" {
  providers = {
    azurerm.private_endpoint = azurerm.private_endpoint
  }
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = local.servicebus_namespace_name
  location            = var.location
  sku                 = "Basic"
  resource_group_name = azurerm_resource_group.shared_resource_group.name
  env                 = var.env
  common_tags         = var.common_tags
  project             = var.project
}

resource "azurerm_servicebus_queue" "this" {
  name         = "recipes"
  namespace_id = module.servicebus-namespace.id
}

data "azurerm_user_assigned_identity" "plum" {
  name                = "plum-${local.env}-mi"
  resource_group_name = "managed-identities-${local.env}-rg"
}

resource "azurerm_role_assignment" "plum_servicebus_data_receiver" {
  principal_id = data.azurerm_user_assigned_identity.plum.principal_id
  scope        = module.servicebus-namespace.id
  role_definition_name = "Azure Service Bus Data Receiver"
}

data "azurerm_user_assigned_identity" "keda" {
  name                = "keda-${local.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

resource "azurerm_role_assignment" "keda_servicebus_data_receiver" {
  principal_id = data.azurerm_user_assigned_identity.keda.principal_id
  scope        = module.servicebus-namespace.id
  role_definition_name = "Azure Service Bus Data Receiver"
}


data "azuread_group" "platops" {
  display_name     = "DTS Platform Operations"
  security_enabled = true
}

resource "azurerm_role_assignment" "platops_servicebus_data_owner" {
  principal_id         = data.azuread_group.platops.object_id
  scope                = module.servicebus-namespace.id
  role_definition_name = "Azure Service Bus Data Owner"
}

