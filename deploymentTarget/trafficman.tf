locals {
  traffic_manager_endpoints = [
    {
      name        = "${local.backend_name}"
      target      = "${data.null_data_source.waf-pip.outputs["pip"]}"
      priority    = "3"
      status      = "Enabled"
      host_header = "${var.public_hostname}" // // This has to be the same hostname used in the listeners of the WAF
    }
  ]
}

data "template_file" "endpoints" {
  template = "${file("${path.module}/templates/traffic-manager-endpoint.tpl")}"
  count    = "1"

  vars {
    name        = "${lookup(local.traffic_manager_endpoints[count.index], "name")}"
    target      = "${lookup(local.traffic_manager_endpoints[count.index], "target")}"
    priority    = "${lookup(local.traffic_manager_endpoints[count.index], "priority")}"
    status      = "${lookup(local.traffic_manager_endpoints[count.index], "status")}"
    host_header = "${lookup(local.traffic_manager_endpoints[count.index], "host_header")}"
  }
}

data "template_file" "traffic_manager_parameters" {
  template = "${file("${path.module}/templates/traffic-manager-parameters.tpl")}"

  vars {
    name      = "${var.product}-${var.env}"
    team_name = "${var.common_tags["Team Name"]}"
    endpoints = "${join(",", data.template_file.endpoints.*.rendered)}"
  }
}

data "template_file" "traffic_manager_template" {
  template = "${file("${path.module}/templates/tm-endpoint.json")}"
}

resource "azurerm_template_deployment" "traffic_manager_enpoints" {
  template_body       = "${data.template_file.traffic_manager_template.rendered}"
  name                = "${var.product}-${var.env}-tm"
  resource_group_name = "${azurerm_resource_group.shared_resource_group.name}"
  deployment_mode     = "Incremental"
  parameters_body     = "${data.template_file.traffic_manager_parameters.rendered}"
}

data "null_data_source" "waf-pip" {
  inputs = {
    pip = "${module.waf.public_ip_fqdn}"     
  }
  depends_on = ["module.waf"]
}

/*
// note: add 'Custom Header settings: "Host:plum.platform.hmcts.net"
resource "azurerm_traffic_manager_endpoint" "endpoint" {
  name                = "${local.backend_name}"
  resource_group_name = "${var.product}-shared-infrastructure-${var.env}"
  profile_name        = "${var.product}-${var.env}"
  target              = "${data.null_data_source.waf-pip.outputs["pip"]}"
  type                = "externalEndpoints"
  weight              = 100
}
*/