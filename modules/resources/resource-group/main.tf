# Resource Group
resource "azurerm_resource_group" "resgrp" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    cluster = var.tag_cluster_name
    group   = var.tag_group_name
    env     = var.tag_env_name
  }
}
