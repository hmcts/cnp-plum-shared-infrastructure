//KEY VAULT RESOURCE

module "vault" {
  source                      = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                        = "${local.vault_name}"
  product                     = "${var.product}"
  env                         = "${var.env}"
  tenant_id                   = "${var.tenant_id}"
  object_id                   = "${var.jenkins_AAD_objectId}"
  resource_group_name         = "${azurerm_resource_group.shared_resource_group.name}"
  product_group_object_id     = "300e771f-856c-45cc-b899-40d78281e9c1"
  common_tags                 = "${local.tags}"
  managed_identity_object_ids = ["${var.managed_identity_object_id}"]
  create_managed_identity     = true
}

output "vaultName" {
  value = "${module.vault.key_vault_name}"
}
