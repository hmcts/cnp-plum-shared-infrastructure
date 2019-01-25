
data "null_data_source" "waf-pip" {
  inputs = {
    pip = "${module.waf.public_ip_fqdn}"     
  }
  depends_on = ["module.waf"]
}

// note: add 'Custom Header settings: "Host:plum.platform.hmcts.net"
resource "azurerm_traffic_manager_endpoint" "endpoint" {
  name                = "${local.backend_name}"
  resource_group_name = "${var.product}-shared-infrastructure-${var.env}"
  profile_name        = "${var.product}-${var.env}"
  target              = "${data.null_data_source.waf-pip.outputs["pip"]}"
  type                = "externalEndpoints"
  weight              = 100
}
