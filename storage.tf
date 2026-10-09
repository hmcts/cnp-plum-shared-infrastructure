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
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  managed_identity_object_id      = azurerm_role_assignment.plum_speech_services_user[0].principal_id
  role_assignments                = ["Storage Blob Data Contributor"]
}

resource "azurerm_private_endpoint" "speech_audio_storage" {
  count    = var.env == "sandbox" ? 1 : 0
  provider = azurerm.private_endpoint

  name                = "${module.speech_audio_storage[0].storageaccount_name}-endpoint"
  resource_group_name = local.cft_aks_network_rg_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.speech_storage_private_endpoint[0].id

  private_service_connection {
    name                           = "${module.speech_audio_storage[0].storageaccount_name}-blob"
    private_connection_resource_id = module.speech_audio_storage[0].storageaccount_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

  tags = local.tags
}

resource "azurerm_storage_container" "speech_audio" {
  count = var.env == "sandbox" ? 1 : 0

  name                  = "audio"
  storage_account_id    = module.speech_audio_storage[0].storageaccount_id
  container_access_type = "private"
}

moved {
  from = module.speech_audio_storage[0].azurerm_storage_container.container["audio"]
  to   = azurerm_storage_container.speech_audio[0]
}
