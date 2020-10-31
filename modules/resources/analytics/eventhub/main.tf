# Random string for prefix
resource "random_string" "prefix" {
  length  = 2
  upper   = false
  lower   = true
  number  = false
  special = false
}

# Azure EventHub
resource "azurerm_eventhub" "eventhub" {
  name                = "${var.cluster_name}-${random_string.prefix.result}-eh"
  namespace_name      = var.eventhub_namespace_name
  resource_group_name = var.resource_group_name
  partition_count     = 2
  message_retention   = 1
}

# Azure Eventhub Consumer Group
resource "azurerm_eventhub_consumer_group" "ehconsumergrp" {
  name                = "${var.cluster_name}-${random_string.prefix.result}-cg"
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
}

# Azure EventHub Admin Authorization Policy
resource "azurerm_eventhub_authorization_rule" "ehadminauthz" {
  name                = "${var.cluster_name}-${random_string.prefix.result}-eh-admin"
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = true
  manage              = true
}

# Azure EventHub Producer Authorization Policy
resource "azurerm_eventhub_authorization_rule" "ehproducerauthz" {
  name                = "${var.cluster_name}-${random_string.prefix.result}-eh-producer"
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

# Azure EventHub Consumer Authorization Policy
resource "azurerm_eventhub_authorization_rule" "ehconsumerauthz" {
  name                = "${var.cluster_name}-${random_string.prefix.result}-eh-consumer"
  namespace_name      = var.eventhub_namespace_name
  eventhub_name       = azurerm_eventhub.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}