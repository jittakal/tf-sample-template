# Random string prefix
resource "random_string" "prefix" {
  length  = 4
  upper   = false
  lower   = true
  number  = false
  special = false
}

# Module to create resource group
module "resource_group" {
  source = "../modules/resources/resource-group"

  resource_group_name     = "${var.cluster_name}-${random_string.prefix.value}-rg"
  resource_group_location = var.resource_group_location

  tag_cluster_name = var.cluster_name
  tag_group_name   = var.tag_group_name
  tag_env_name     = var.tag_env_name
}

# Module to create storage account
module "storage_account" {
  source = "../modules/resources/storage/account"

  storage_account_name             = substr(replace(lower("${var.cluster_name}-${random_string.prefix.result}-sa"), "/[^a-z]+/", ""), 0, 23)
  resource_group_name              = module.resource_group.resource_group_name
  resource_group_location          = module.resource_group.resource_group_location
  storage_account_tier             = var.storage_account_tier
  storage_account_replication_type = var.storage_account_replication_type
  storage_hrs_enabled              = var.storage_hrs_enabled

  tag_cluster_name = var.cluster_name
  tag_group_name   = var.tag_group_name
  tag_env_name     = var.tag_env_name
}

# Storage Blob Containers
module "storage_container_dfinput" {
  source = "../modules/resources/storage/blob-containers"

  cluster_name         = "${var.cluster_name}-df-input"
  storage_account_name = module.storage_account.storage_account_name
}

module "storage_container_dfoutput" {
  source = "../modules/resources/storage/blob-containers"

  cluster_name         = "${var.cluster_name}-df-output"
  storage_account_name = module.storage_account.storage_account_name
}

module "storage_container_saoutput" {
  source = "../modules/resources/storage/blob-containers"

  cluster_name         = "${var.cluster_name}-sa-output"
  storage_account_name = module.storage_account.storage_account_name
}

# MySQL Database Server
module "database_mysql" {
  source = "../modules/resources/database/mysql"

  cluster_name            = var.cluster_name
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = var.resource_group_location
  mysql_admin_username    = var.mysql_admin_username
  mysql_admin_password    = var.mysql_admin_password
  mysql_database_name     = var.mysql_database_name


  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}

# EventHub Namespace
module "eventhub_namespace" {
  source = "../modules/resources/analytics/eventhub-namespace"

  cluster_name            = var.cluster_name
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = var.resource_group_location
  eventhub_ns_capacity    = var.eventhub_ns_capacity

  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}

# EventHub
module "eventhub_1" {
  source = "../modules/resources/analytics/eventhub"

  cluster_name            = var.cluster_name
  resource_group_name     = module.resource_group.resource_group_name
  eventhub_namespace_name = module.eventhub_namespace.eventhub_namespace_name

  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}

# EventHub
module "eventhub_2" {
  source = "../modules/resources/analytics/eventhub"

  cluster_name            = var.cluster_name
  resource_group_name     = module.resource_group.resource_group_name
  eventhub_namespace_name = module.eventhub_namespace.eventhub_namespace_name

  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}

# Data Factory
module "data_factory" {
  source = "../modules/resources/analytics/data-factory"

  cluster_name            = var.cluster_name
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = var.resource_group_location

  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}


## Analytics Application Componenets

# Module Data Factory Pipelines
module "data_pipelines" {
  source = "../modules/apps/analytics/data-factory-pipelines"

  cluster_name                  = var.cluster_name
  resource_group_name           = module.resource_group.resource_group_name
  resource_group_location       = var.resource_group_location
  data_factory_name             = module.data_factory.data_factory_name
  storage_account_name          = module.storage_account.storage_account_name
  storage_account_id            = module.storage_account.storage_account_id
  storage_account_connection    = module.storage_account.storage_account_connection
  input_storage_container_name  = module.storage_blob.dfinput_blob_container_name
  output_storage_container_name = module.storage_blob.dfoutput_blob_container_name
  mysql_server_name             = module.database_mysql.mysql_server_name
  mysql_admin_username          = var.mysql_admin_username
  mysql_admin_password          = var.mysql_admin_password
  mysql_database_name           = var.mysql_database_name
  dataset_table_name            = var.dataset_table_name

  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}

# Module Stream Analytics Jobs
module "stream_analytics" {
  source = "../modules/apps/analytics/stream-analytics-jobs"

  cluster_name                 = var.cluster_name
  resource_group_name          = module.resource_group.resource_group_name
  resource_group_location      = var.resource_group_location
  storage_account_name         = module.storage_account.storage_account_name
  storage_account_key          = module.storage_account.storage_account_key
  ref_storage_container_name   = module.storage_blob.dfoutput_blob_container_name
  out_storage_container_name   = module.storage_blob.saoutput_blob_container_name
  eventhub_consumer_group_name = module.eventhub_1.eventhub_consumer_group_name
  eventhub_name                = module.eventhub_1.eventhub_name
  servicebus_namespace         = module.eventhub_namespace.eventhub_namespace_name
  shared_access_policy_key     = module.eventhub_1.shared_access_policy_key
  shared_access_policy_name    = module.eventhub_1.shared_access_policy_name

  tag_group_name = var.tag_group_name
  tag_env_name   = var.tag_env_name
}

# Module Azure Data Explorer Cluster
module "adx_cluster" {
  source = "../modules/resources/analytics/kusto-cluster"

  cluster_name            = var.cluster_name
  kusto_cluster_name      = substr(replace(lower("${var.cluster_name}-adx"), "/[^a-z]+/", ""), 0, 23)
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = var.resource_group_location
}
