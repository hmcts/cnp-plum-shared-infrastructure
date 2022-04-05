variable "project" {
  default     = "cft"
}

locals {
  servicebus_namespace_name = "${var.product}-servicebus-${var.env}"
}

module "servicebus-namespace" {
  providers = {
    azurerm.private-endpoint = azurerm.private-endpoint
  }
  source                  = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=DTSPO-6371_remove_provider"
  name                    = local.servicebus_namespace_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.shared_resource_group.name
  env                     = var.env
  common_tags             = var.common_tags
  project                 = var.project
  capacity                = 1
  enable_private_endpoint = true
}