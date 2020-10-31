output "resource_group_name" {
  value       = azurerm_resource_group.resgrp.name
  description = "Resource group name"
}

output "resource_group_location" {
  value      = azurerm_resource_group.resgrp.location
  desription = "Resource group location"
}
