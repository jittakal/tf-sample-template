# Azure EventHub Namespace
resource "azurerm_eventhub_namespace" "ehnamespace" {
  name                = "${var.cluster_name}-ehns"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  capacity            = var.eventhub_ns_capacity

  tags = {
    cluster = var.cluster_name
    group   = var.tag_group_name
    env     = var.tag_env_name
  }
}
