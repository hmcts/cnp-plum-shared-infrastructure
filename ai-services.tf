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
