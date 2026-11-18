# Batch transcription test rig for the AI Gateway (DTSPO-36570). Sandbox only.
# The Speech account is created with its own storage (BYOS), so results land in that storage.

data "azurerm_client_config" "current" {}

locals {
  speech_batch_account_name = "${var.product}-speech-batch-${var.env}"
  speech_batch_storage_name = "${replace(var.product, "-", "")}batch${var.env}"
}

# The Speech service reaches this storage as a trusted service, not through the private endpoint,
# so public network access stays on with a deny default and a resource instance rule for the account.
module "speech_batch_storage" {
  count  = var.env == "sandbox" ? 1 : 0
  source = "git@github.com:hmcts/cnp-module-storage-account?ref=4.x"

  env                       = var.env
  storage_account_name      = local.speech_batch_storage_name
  resource_group_name       = azurerm_resource_group.shared_resource_group.name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  common_tags               = local.tags

  default_action                  = "Deny"
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false
  private_link_access = {
    speech_batch = {
      endpoint_resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.shared_resource_group.name}/providers/Microsoft.CognitiveServices/accounts/${local.speech_batch_account_name}"
    }
  }
  managed_identity_object_id = azurerm_role_assignment.plum_speech_services_user[0].principal_id
  role_assignments           = ["Storage Blob Data Contributor"]
}

resource "azurerm_private_endpoint" "speech_batch_storage" {
  count    = var.env == "sandbox" ? 1 : 0
  provider = azurerm.private_endpoint

  name                = "${module.speech_batch_storage[0].storageaccount_name}-endpoint"
  resource_group_name = local.cft_aks_network_rg_name
  location            = var.location
  subnet_id           = data.azurerm_subnet.speech_storage_private_endpoint[0].id

  private_service_connection {
    name                           = "${module.speech_batch_storage[0].storageaccount_name}-blob"
    private_connection_resource_id = module.speech_batch_storage[0].storageaccount_id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

  tags = local.tags
}

resource "azurerm_storage_container" "speech_batch_audio" {
  count = var.env == "sandbox" ? 1 : 0

  name                  = "audio"
  storage_account_id    = module.speech_batch_storage[0].storageaccount_id
  container_access_type = "private"
}

module "speech_batch" {
  count                           = var.env == "sandbox" ? 1 : 0
  existing_cognitive_account_name = local.speech_batch_account_name
  source                          = "git@github.com:hmcts/terraform-module-ai-services?ref=feat/cognitive-account-own-storage"

  providers = {
    azurerm.private_dns = azurerm # required alias; unused since enable_managed_network = false skips all PE/DNS lookups
  }

  env         = var.env
  product     = var.product
  project     = var.project
  component   = "speech-batch"
  common_tags = local.tags

  existing_resource_group_name = azurerm_resource_group.shared_resource_group.name
  location                     = var.location

  create_ai_foundry        = false
  create_storage_account   = false
  create_cognitive_account = true
  enable_managed_network   = false

  cognitive_account_kind = "SpeechServices"
  cognitive_account_sku  = "S0"

  public_network_access_cognitive               = false
  cognitive_account_network_acls_default_action = "Deny"
  cognitive_account_local_auth_enabled          = false

  cognitive_account_outbound_network_access_restricted = true
  cognitive_account_fqdns                              = ["${local.speech_batch_storage_name}.blob.core.windows.net"]
  cognitive_account_storage_account_id                 = module.speech_batch_storage[0].storageaccount_id
}

resource "azurerm_role_assignment" "ai_gateway_speech_batch_user" {
  count = var.env == "sandbox" ? 1 : 0

  scope                = module.speech_batch[0].cognitive_account_id
  role_definition_name = "Cognitive Services Speech User"
  principal_id         = "4425c586-7c27-49a9-84bc-183ad2b8ce82" # sps-ai-sbox-mi (AI Gateway)
}

output "speech_batch_cognitive_account_id" {
  value       = length(module.speech_batch) == 0 ? null : module.speech_batch[0].cognitive_account_id
  description = "ID of the BYOS Speech account for batch transcription (sandbox only; null elsewhere)."
}

output "speech_batch_storage_account_name" {
  value       = length(module.speech_batch_storage) == 0 ? null : module.speech_batch_storage[0].storageaccount_name
  description = "Storage account bound to the batch Speech account (sandbox only; null elsewhere)."
}
