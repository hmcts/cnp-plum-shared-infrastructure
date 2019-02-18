
module "trafficManagerProfileEndpoint" {
  source                  = "git@github.com:hmcts/cnp-module-trafficmanager-endpoint?ref=master"
  backend_name            = "${local.backend_name}"
  backend_pip             = "${data.null_data_source.waf-pip.outputs["pip"]}"
  public_hostname         = "${var.public_hostname}"
  priority                = "3"   // 1 = shutter-page, 2 = legacy, 3 = DT
  product                 = "${var.product}"
  env                     = "${var.env}"
  common_tags             = "${var.common_tags}"
  resource_group          = "${var.product}-shared-infrastructure-${var.env}"
}


data "null_data_source" "waf-pip" {
  inputs = {
    pip = "${module.waf.public_ip_fqdn}"     
  }
  depends_on = ["module.waf"]
}


