output "storage_account_name" {
  value       = azurerm_storage_account.saccount.name
  description = " The name of storage account"
}

output "storage_account_connection" {
  sensitive   = true
  value       = azurerm_storage_account.saccount.primary_connection_string
  description = "Storage Account primary connection string"
}

output "storage_account_id" {
  sensitive   = true
  value       = azurerm_storage_account.saccount.id
  description = "Storage Account Id"
}

output "storage_account_key" {
  sensitive   = true
  value       = azurerm_storage_account.saccount.primary_access_key
  description = "Storage account primary access key"
}
