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
  description = "The resource group location name or code"
}

variable "kusto_cluster_name" {
  type        = string
  description = "Kusto Cluster Name"
}

variable "kusto_sku_name" {
  type        = string
  default     = "Standard_D13_v2"
  description = "Kusto SKU Name"
}

variable "kusto_minimum_instances" {
  type        = number
  default     = 2
  description = "Kusto Minimum Instances"
}

variable "kusto_maximum_instances" {
  type        = number
  default     = 3
  description = "Kusto Maximum Instances"
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
