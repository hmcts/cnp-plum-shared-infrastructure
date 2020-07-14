provider "azurerm" {
  
  version = "=2.18.0"
}

locals {
  vault_name = "${var.product}si-${var.env}"
  
  tags = merge(
    var.common_tags,
    map("Team Contact", var.team_contact)
  )

}

//SHARED RESOURCE GROUP
resource "azurerm_resource_group" "shared_resource_group" {
  name     = "${var.product}-shared-infrastructure-${var.env}"
  location = var.location

  tags = local.tags
}


