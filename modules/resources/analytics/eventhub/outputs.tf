output "eventhub_name" {
  value       = azurerm_eventhub.eventhub.name
  description = " The name of eventhub name"
}

output "shared_access_policy_key" {
  sensitive   = true
  value       = azurerm_eventhub_authorization_rule.ehconsumerauthz.primary_key
  description = "Shared access policy key"
}

output "shared_access_policy_name" {
  value       = azurerm_eventhub_authorization_rule.ehconsumerauthz.name
  description = "Shared access policy name"
}

output "eventhub_consumer_group_name" {
  value       = azurerm_eventhub_consumer_group.ehconsumergrp.name
  description = "Eventhub Consumer Group Name"
}
