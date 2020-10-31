output "dfinput_blob_container_name" {
  value       = azurerm_storage_container.dfinput.name
  description = "The storage blob container name"
}

output "dfoutput_blob_container_name" {
  value       = azurerm_storage_container.dfoutput.name
  description = "The storage blob container name"
}

output "saoutput_blob_container_name" {
  value       = azurerm_storage_container.saoutput.name
  description = "The storage blob container name"
}
