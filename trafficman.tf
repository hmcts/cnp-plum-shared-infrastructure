module "trafficManagerProfile" {
  source                  = "git@github.com:hmcts/cnp-module-trafficmanager?ref=master"
  backend_name            = "${local.backend_name}"
  backend_pip             = "${module.waf.public_ip_fqdn}" 
  public_hostname         = "${var.public_hostname}"
  product                 = "${var.product}"
  env                     = "${var.env}"
  common_tags             = "${var.common_tags}"
  resource_group          = "${azurerm_resource_group.shared_resource_group.name}"
}