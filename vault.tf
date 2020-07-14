//KEY VAULT RESOURCE

resource "azurerm_user_assigned_identity" "plum-identity" {

  resource_group_name = "managed-identities-${var.env}-rg"
  location            = "${var.location}"

  name = "${var.product}-${var.env}-mi"

  tags = "${var.common_tags}"
}

module "vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "${local.vault_name}"
  product                 = "${var.product}"
  env                     = "${var.env}"
  tenant_id               = "${var.tenant_id}"
  object_id               = "${var.jenkins_AAD_objectId}"
  resource_group_name     = "${azurerm_resource_group.shared_resource_group.name}"
  product_group_object_id = "300e771f-856c-45cc-b899-40d78281e9c1"
  common_tags = "${local.tags}"
  managed_identity_object_ids= ["${var.managed_identity_object_id}"]
}

output "vaultName" {
  value = "${module.vault.key_vault_name}"
}

output "team_identity_client_id" {
  value = "${azurerm_user_assigned_identity.plum-identity.client_id}"
}
