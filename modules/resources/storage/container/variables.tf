variable "storage_container_name" {
  type        = string
  description = "Storage container name"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "container_access_type" {
  type = string
  default = "private"
  description "Storage container access type"
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
