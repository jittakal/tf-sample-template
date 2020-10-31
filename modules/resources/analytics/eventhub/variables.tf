variable "cluster_name" {
  type        = string
  description = "The name to use as a cluster name"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name"
}

variable "eventhub_namespace_name" {
  type        = string
  description = "The eventhub namespace name"
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
