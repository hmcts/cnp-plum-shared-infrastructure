locals {
  backend_name = "${var.product}-frontend-${var.env}"
  backend_hostname = "${local.backend_name}.service.core-compute-${var.env}.internal"
}

data "azurerm_key_vault_secret" "cert" {
  name      = "${var.certificate_name}"
  vault_uri = "https://infra-vault-${var.subscription}.vault.azure.net/"
}

data "azurerm_subnet" "app_gateway_subnet" {
  name                 = "${var.infra_location}-subnet-0-${var.env}"
  virtual_network_name = "${var.infra_location}-vnet-${var.env}"
  resource_group_name  = "${var.infra_location}-${var.env}"
}

module "waf" {
  source            = "git@github.com:hmcts/cnp-module-waf?ref=master"
  env               = "${var.env}"
  subscription      = "${var.subscription}"
  location          = "${var.location}"
  wafName           = "${var.product}"
  resourcegroupname = "${azurerm_resource_group.shared_resource_group.name}"
  use_authentication_cert = true

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.app_gateway_subnet.id}"
    },
  ]

  sslCertificates = [
    {
      name     = "${var.certificate_name}"
      data     = "${data.azurerm_key_vault_secret.cert.value}"
      password = ""
    },
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "${var.product}-http-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort80"
      Protocol                = "Http"
      SslCertificate          = ""
      hostName                = "${var.public_hostname}"
    },
    {
      name                    = "${var.product}-https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.certificate_name}"
      hostName                = "${var.public_hostname}"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${local.backend_name}"
      backendAddresses = [
        {
          ipAddress = "${local.backend_hostname}"
        },
      ]
    },
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend-80-nocookies"
      port                           = 80
      Protocol                       = "Http"
      CookieBasedAffinity            = "Disabled"
      AuthenticationCertificates     = ""
      probeEnabled                   = "True"
      probe                          = "http-probe"
      PickHostNameFromBackendAddress = "True"
      HostName                       = ""
    },
    {
      name                           = "backend-443-nocookies"
      port                           = 443
      Protocol                       = "Https"
      CookieBasedAffinity            = "Disabled"
      AuthenticationCertificates     = "ilbCert"
      probeEnabled                   = "True"
      probe                          = "https-probe"
      PickHostNameFromBackendAddress = "True"
      HostName                       = ""
    },
  ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                = "${var.product}-http"
      RuleType            = "Basic"
      httpListener        = "${var.product}-http-listener"
      backendAddressPool  = "${local.backend_name}"
      backendHttpSettings = "backend-80-nocookies"
    },
    {
      name                = "${var.product}-https"
      RuleType            = "Basic"
      httpListener        = "${var.product}-https-listener"
      backendAddressPool  = "${local.backend_name}"
      backendHttpSettings = "backend-443-nocookies"
    },
  ]

  probes = [
    {
      name                                = "http-probe"
      protocol                            = "Http"
      path                                = "${var.health_check}"
      interval                            = "${var.health_check_interval}"
      timeout                             = 30
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-80-nocookies"
      host                                = "${local.backend_hostname}"
      healthyStatusCodes                  = "200-399"
    },
    {
      name                                = "https-probe"
      protocol                            = "Https"
      path                                = "${var.health_check}"
      interval                            = "${var.health_check_interval}"
      timeout                             = 30
      unhealthyThreshold                  = "${var.unhealthy_threshold}"
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend-443-nocookies"
      host                                = "${local.backend_hostname}"
      healthyStatusCodes                  = "200-399"
    },
  ]
}
