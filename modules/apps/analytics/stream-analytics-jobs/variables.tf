variable "cluster_name" {
  type        = string
  description = "The name to use as a cluster name"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "The region location name or code"
}

variable "storage_account_name" {
  type        = string
  description = "The storage account name"
}

variable "storage_account_key" {
  type        = string
  description = "The storage account key"
}

variable "ref_storage_container_name" {
  type        = string
  description = "The storage container name"
}

variable "out_storage_container_name" {
  type        = string
  description = "The storage container name"
}

variable "eventhub_consumer_group_name" {
  type        = string
  description = "Eventhub Consumer Group Name"
}

variable "eventhub_name" {
  type        = string
  description = "Eventhub Name"
}

variable "servicebus_namespace" {
  type        = string
  description = "Eventhub or Servicebus Namespace"
}
variable "shared_access_policy_key" {
  type        = string
  description = "Shared access policy key"
}

variable "shared_access_policy_name" {
  type        = string
  description = "Shared access policy name"
}

variable "tag_cluster_name" {
  type        = string
  description = "Tag cluster name"
}

variable "tag_group_name" {
  type        = string
  description = "Tag group name"
}

variable "tag_env_name" {
  type        = string
  description = "Tag environment name"
}
