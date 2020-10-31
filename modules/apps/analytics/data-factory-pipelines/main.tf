# Azure Data Factory Linked Service
resource "azurerm_data_factory_linked_service_azure_blob_storage" "dflsrvblob" {
  name                = replace(lower("${var.cluster_name}df-lsrv-blob"), "/[^a-z]+/", "")
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
  connection_string   = var.storage_account_connection
}

# Azure Data Factory Blob Storage Input Dataset
resource "azurerm_data_factory_dataset_azure_blob" "indataset1" {
  name                = replace(lower("${var.cluster_name}-fasttags-in-ds"), "/[^a-z]+/", "")
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.dflsrvblob.name

  path     = "${var.input_storage_container_name}/fasttags"
  filename = "fasttag.csv"
}

# Azure Data Factory Blob Storage Input Dataset
resource "azurerm_data_factory_dataset_azure_blob" "outdataset1" {
  name                = replace(lower("${var.cluster_name}-fasttags-out-ds"), "/[^a-z]+/", "")
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.dflsrvblob.name

  path     = "${var.output_storage_container_name}/fasttags/"
  filename = "fasttag.csv"
}

# Azure Data Factory Pipeline for Blob to Blob Data Copy
resource "azurerm_data_factory_pipeline" "dfpipeline1" {
  name                = "${var.cluster_name}-df-pipeline1"
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name

  activities_json = templatefile("${path.module}/templates/datafactory-pipeline1.json", {
    input_reference_name  = azurerm_data_factory_dataset_azure_blob.indataset1.name
    output_reference_name = azurerm_data_factory_dataset_azure_blob.outdataset1.name
  })

  depends_on = []
}

# Azure Data Factory Trigger - On Blob Create Event
resource "azurerm_template_deployment" "trigger" {
  name                = "${var.input_storage_container_name}-event-trigger"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  template_body = file("${path.module}/templates/datafactory-event-trigger-template.json")

  parameters = {
    "dataFactoryName"    = var.data_factory_name,
    "triggerName"        = "on-blob-create-event",
    "storageAccountId"   = var.storage_account_id,
    "containerName"      = var.input_storage_container_name,
    "pipelineName"       = azurerm_data_factory_pipeline.dfpipeline1.name,
    "blobPathBeginsWith" = "fasttags/fasttag.csv"
  }

  depends_on = []
}

# Azure Data Factory Linked Service for MySQL
resource "azurerm_data_factory_linked_service_mysql" "dflsrcmysql" {
  name                = replace(lower("${var.cluster_name}-df-lsrv-mysql"), "/[^a-z]+/", "")
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
  connection_string   = "Server=${var.mysql_server_name}.mysql.database.azure.com;Port=3306;Database=${var.mysql_database_name};User=${var.mysql_admin_username}@${var.mysql_server_name};SSLMode=1;UseSystemTrustStore=0;Password=${var.mysql_admin_password}"
}

# Azure Data Factory Dataset
resource "azurerm_data_factory_dataset_mysql" "indataset2" {
  name                = replace(lower("${var.cluster_name}-vehicles-in-ds"), "/[^a-z]+/", "")
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
  linked_service_name = azurerm_data_factory_linked_service_mysql.dflsrcmysql.name
  table_name          = var.dataset_table_name
}

# Azure Data Factory Blob Storage Input Dataset
resource "azurerm_data_factory_dataset_delimited_text" "outdataset2" {
  name                = replace(lower("${var.cluster_name}-vehicles-out-ds"), "/[^a-z]+/", "")
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.dflsrvblob.name

  azure_blob_storage_location {
    container = var.output_storage_container_name
    path      = "vehicles"
    filename  = "vehicle.csv"
  }

  column_delimiter    = ","
  row_delimiter       = "\r"
  encoding            = "UTF-8"
  first_row_as_header = true
  null_value          = "NULL"
}

# Azure Data Factory Pipeline for MySQL to Blob Data Copy
resource "azurerm_data_factory_pipeline" "dfpipeline2" {
  name                = "${var.cluster_name}-df-pipeline2"
  resource_group_name = var.resource_group_name
  data_factory_name   = var.data_factory_name

  activities_json = templatefile("${path.module}/templates/datafactory-pipeline2.json", {
    input_reference_name  = azurerm_data_factory_dataset_mysql.indataset2.name
    output_reference_name = azurerm_data_factory_dataset_delimited_text.outdataset2.name
    dataset_table_name    = var.dataset_table_name
  })

  depends_on = []
}
