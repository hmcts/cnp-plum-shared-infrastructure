

locals {
  traffic_manager_endpoints = [
    {
      name        = "shutter-page"
      target      = "mojmaintenance.azurewebsites.net"
      priority    = "1"
      status      = "Disabled"
      host_header = ""
    },
    {
      name        = "${local.backend_name}"
      target      = "${module.waf.public_ip_fqdn}" 
      priority    = "2"
      status      = "Enabled"
      host_header = "${var.public_hostname}" // // This has to be the same hostname used in the listeners of the WAF
    }
  ]
}

module "trafficManagerProfile" {
  source                    = "git@github.com:hmcts/cnp-module-trafficmanager?ref=master"
  org_name                  =  "hmcts"
  product                   = "${var.product}"
  env                       = "${var.env}"
  common_tags               = "${var.common_tags}"
  resource_group            = "${azurerm_resource_group.shared_resource_group.name}"
  traffic_manager_endpoints = "${local.traffic_manager_endpoints}"
  endpoints_count           = "2"
}