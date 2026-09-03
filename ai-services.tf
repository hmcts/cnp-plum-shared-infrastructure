# AI Services cognitive account (AIServices kind) with a single gpt-4o
# deployment. Sandbox-only. No private endpoint is created here — one is
# attached later by a separate process — but the account is fully
# configured for private-only access (no public network access, deny-all
# ACL default, Entra-ID-only auth) so it's ready as soon as that PE exists.
module "ai_services" {
  count = var.env == "sandbox" ? 1 : 0

  source = "github.com/hmcts/terraform-module-ai-services?ref=main"

  providers = {
    azurerm.private_dns = azurerm # required alias; unused since enable_managed_network = false skips all PE/DNS lookups
  }

  env         = var.env
  product     = var.product
  project     = var.project
  component   = "ai-services"
  common_tags = local.tags

  existing_resource_group_name = azurerm_resource_group.shared_resource_group.name
  location                     = var.location

  create_ai_foundry        = false
  create_storage_account   = false
  create_cognitive_account = true
  enable_managed_network   = false

  cognitive_account_kind = "AIServices"
  cognitive_account_sku  = "S0"

  public_network_access_cognitive                      = false
  cognitive_account_network_acls_default_action        = "Deny"
  cognitive_account_local_auth_enabled                 = false
  cognitive_account_outbound_network_access_restricted = true

  cognitive_deployments = {
    "gpt-4o" = {
      model_name    = "gpt-4o"
      model_version = "2024-11-20"
      sku_name      = "GlobalStandard"
      sku_capacity  = 1
    }
  }
}

module "document_intelligence" {
  count = var.env == "sandbox" ? 1 : 0

  source = "github.com/hmcts/terraform-module-ai-services?ref=main"

  providers = {
    azurerm.private_dns = azurerm # required alias; unused since enable_managed_network = false skips all PE/DNS lookups
  }

  env         = var.env
  product     = var.product
  project     = var.project
  component   = "doc-intelligence"
  common_tags = local.tags

  existing_resource_group_name = azurerm_resource_group.shared_resource_group.name
  location                     = var.location

  create_ai_foundry        = false
  create_storage_account   = false
  create_cognitive_account = true
  enable_managed_network   = false

  cognitive_account_kind = "FormRecognizer"
  cognitive_account_sku  = "S0"

  public_network_access_cognitive                      = false
  cognitive_account_network_acls_default_action        = "Deny"
  cognitive_account_local_auth_enabled                 = false
  cognitive_account_outbound_network_access_restricted = true
}

resource "azurerm_role_assignment" "plum_ai_services_openai_user" {
  count = var.env == "sandbox" ? 1 : 0

  scope                = module.ai_services[0].cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = "b2f0690f-1b5c-4b4e-988f-639314878f3b" # plum-sandbox-mi
}

# The AI Gateway calls this account as itself once the private endpoint routes to it,
# so its managed identity needs data-plane access here. This is a data action, so it
# is not covered by any control-plane role the gateway's subscription already holds.
resource "azurerm_role_assignment" "ai_gateway_ai_services_openai_user" {
  count = var.env == "sandbox" ? 1 : 0

  scope                = module.ai_services[0].cognitive_account_id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = "4425c586-7c27-49a9-84bc-183ad2b8ce82" # sps-ai-sbox-mi (AI Gateway)
}

resource "azurerm_role_assignment" "plum_document_intelligence_user" {
  count = var.env == "sandbox" ? 1 : 0

  scope                = module.document_intelligence[0].cognitive_account_id
  role_definition_name = "Cognitive Services User"
  principal_id         = "b2f0690f-1b5c-4b4e-988f-639314878f3b" # plum-sandbox-mi
}

resource "azurerm_role_assignment" "ai_gateway_document_intelligence_user" {
  count = var.env == "sandbox" ? 1 : 0

  scope                = module.document_intelligence[0].cognitive_account_id
  role_definition_name = "Cognitive Services User"
  principal_id         = "4425c586-7c27-49a9-84bc-183ad2b8ce82" # sps-ai-sbox-mi (AI Gateway)
}

