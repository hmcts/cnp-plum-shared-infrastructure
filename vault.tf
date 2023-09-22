//KEY VAULT RESOURCE

module "vault" {
  source                      = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                        = local.vault_name
  product                     = var.product
  env                         = var.env
  tenant_id                   = var.tenant_id
  object_id                   = var.jenkins_AAD_objectId
  resource_group_name         = azurerm_resource_group.shared_resource_group.name
  product_group_object_id     = "e7ea2042-4ced-45dd-8ae3-e051c6551789"
  common_tags                 = local.tags
  managed_identity_object_id = var.managed_identity_object_id
  create_managed_identity     = true
  additional_managed_identities_access = var.additional_managed_identities_access
}

output "vaultName" {
  value = module.vault.key_vault_name
}

resource "azurerm_user_assigned_identity" "managed_identity" {

  resource_group_name = "managed-identities-${var.env}-rg"
  location            = var.location

  name = "chart-tests-${var.env}-mi"

  tags  = var.common_tags
  count = var.create_chart_tests_mi ? 1 : 0
}
