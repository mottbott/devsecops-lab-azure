variable "app_name" {
  description = "Name of the App Service (Linux Web App)."
  type        = string
}

variable "plan_name" {
  description = "Name of the App Service Plan."
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

variable "app_service_sku" {
  description = "App Service Plan SKU name (e.g. B1)."
  type        = string
  default     = "B1"
}

variable "log_analytics_workspace_id" {
  description = "Workspace ID for diagnostic settings."
  type        = string
}

variable "bootstrap_image_name" {
  description = "Initial container image (path:tag) used until the pipeline pushes the real image."
  type        = string
  default     = "azuredocs/aci-helloworld:latest"
}

variable "bootstrap_image_registry" {
  description = "Initial container registry URL used until the pipeline pushes the real image."
  type        = string
  default     = "https://mcr.microsoft.com"
}

variable "health_check_path" {
  description = "Path probed by App Service health check."
  type        = string
  default     = "/healthz"
}

variable "container_port" {
  description = "Port the container listens on; set via WEBSITES_PORT."
  type        = number
  default     = 8000
}

variable "allowed_ingress_ips" {
  description = "Optional list of CIDRs allowed to hit the App Service. Empty list = no IP restriction."
  type        = list(string)
  default     = []
}

variable "app_settings_extra" {
  description = "Additional app settings merged into the App Service configuration."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to App Service Plan and App Service."
  type        = map(string)
  default     = {}
}
