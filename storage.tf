module "speech_audio_storage" {
  count  = var.env == "sandbox" ? 1 : 0
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=4.x"

  env                       = var.env
  storage_account_name      = "${replace(var.product, "-", "")}speech${var.env}"
  resource_group_name       = azurerm_resource_group.shared_resource_group.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  common_tags               = local.tags

  default_action                  = "Deny"
  public_network_access_enabled   = true
  sa_subnets                      = local.speech_storage_subnets
  allow_nested_items_to_be_public = false
  managed_identity_object_id      = azurerm_role_assignment.plum_speech_services_user[0].principal_id
  role_assignments                = ["Storage Blob Data Contributor"]

  containers = [
    {
      name        = "audio"
      access_type = "private"
    }
  ]
}
