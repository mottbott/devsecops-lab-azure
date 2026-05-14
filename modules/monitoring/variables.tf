variable "name" {
  description = "Name of the Log Analytics workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "retention_in_days" {
  description = "Workspace data retention in days."
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "Daily ingestion cap in GB."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags applied to the workspace."
  type        = map(string)
  default     = {}
}
