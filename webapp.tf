module "frontend" {
  source = "git@github.com:hmcts/cnp-module-webapp?ref=DTSPO-30615-modernise-module"

  product             = var.product
  env                 = var.env
  webapp_name         = "plum-frontend"
  resource_group_name = azurerm_resource_group.shared_resource_group.name
  os_type             = "linux"
  is_frontend         = true
  service_plan_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/plum-shared-infrastructure-aat/providers/Microsoft.Web/serverFarms/plum-frontend-asp"

  virtual_network_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/aks-infra-cft-aat-rg/providers/Microsoft.Network/virtualNetworks/cft-aat-vnet/subnets/aat"

  docker_image_name   = "hello-world:latest"
  docker_registry_url = "https://mcr.microsoft.com"

  auth_client_id       = "00000000-0000-0000-0000-000000000000"
  auth_tenant_endpoint = "https://login.microsoftonline.com/${var.tenant_id}/v2.0"

  allowed_external_redirect_urls = [
    "https://my-product-dev.example.com",
    "https://my-product-dev.example.com/",
  ]

  diagnostics_enabled           = true
  event_hub_name                = "plum-frontend-eh"
  eventub_authorization_rule_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/plum-shared-infrastructure-aat/providers/Microsoft.EventHub/namespaces/plum-eh/authorizationRules/plum-eh-auth-rule"

  private_endpoint_enabled   = true
  private_endpoint_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/aks-infra-cft-aat-rg/providers/Microsoft.Network/virtualNetworks/cft-aat-vnet/subnets/aat"
}

module "backend" {
  source = "git@github.com:hmcts/cnp-module-webapp?ref=DTSPO-30615-modernise-module"

  product             = var.product
  env                 = var.env
  webapp_name         = "plum-backend"
  resource_group_name = azurerm_resource_group.shared_resource_group.name
  os_type             = "linux"
  is_frontend         = false
  service_plan_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/plum-shared-infrastructure-aat/providers/Microsoft.Web/serverFarms/plum-backend-asp"

  virtual_network_subnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/aks-infra-cft-aat-rg/providers/Microsoft.Network/virtualNetworks/cft-aat-vnet/subnets/aat"

  docker_image_name   = "hello-world:latest"
  docker_registry_url = "https://mcr.microsoft.com"

  auth_client_id       = "00000000-0000-0000-0000-000000000000"
  auth_tenant_endpoint = "https://login.microsoftonline.com/${var.tenant_id}/v2.0"

  allowed_external_redirect_urls = [
    "https://my-product-dev.example.com",
    "https://my-product-dev.example.com/",
  ]

}
