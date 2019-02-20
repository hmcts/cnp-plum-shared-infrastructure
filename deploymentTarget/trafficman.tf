
locals {
  priority = "${var.deployment_target == "-v2" ? "3" : (var.deployment_target == "-v3" ? "4" : "0")}" 
}

module "trafficManagerProfileEndpoint" {
  source                  = "git@github.com:hmcts/cnp-module-trafficmanager-endpoint?ref=master"
  backend_name            = "${local.backend_name}"
  backend_pip             = "${module.waf.public_ip_fqdn}" 
  public_hostname         = "${var.public_hostname}"
  priority                = "${local.priority}"
  product                 = "${var.product}"
  env                     = "${var.env}"
  common_tags             = "${var.common_tags}"
  resource_group          = "${var.product}-shared-infrastructure-${var.env}"
}