# Azure Data Factory
resource "azurerm_data_factory" "datafactory" {
  name                = "${var.cluster_name}-df"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}
