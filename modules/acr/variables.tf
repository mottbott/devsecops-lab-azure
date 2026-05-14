variable "name" {
  description = "Name of the Azure Container Registry. Must be alphanumeric, lowercase, 5-50 chars."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.name))
    error_message = "ACR name must be 5-50 lowercase alphanumeric characters."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Workspace ID for diagnostic settings."
  type        = string
}

variable "tags" {
  description = "Tags applied to the ACR."
  type        = map(string)
  default     = {}
}
