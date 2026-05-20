variable "name" {
  description = "Key Vault name. 3-24 chars, alphanumeric + hyphens, globally unique."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.name))
    error_message = "Key Vault name must be 3-24 chars, start with a letter, alphanumeric/hyphen."
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

variable "tenant_id" {
  description = "Entra tenant ID the Key Vault is bound to."
  type        = string
}

variable "app_service_principal_id" {
  description = "Object ID of the App Service system-assigned MI. Gets read-only secret access."
  type        = string
}

variable "deployer_object_id" {
  description = "Object ID of the principal running terraform apply. Needs data-plane access to seed the demo secret."
  type        = string
}

variable "demo_secret_name" {
  description = "Name of the example secret created in the vault."
  type        = string
  default     = "demo-message"
}

variable "demo_secret_value" {
  description = "Value of the example secret."
  type        = string
  default     = "Hello from Key Vault"
}

variable "tags" {
  description = "Tags applied to the Key Vault."
  type        = map(string)
  default     = {}
}
