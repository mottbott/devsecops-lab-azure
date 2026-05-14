variable "subscription_id" {
  description = "Azure Subscription ID."
  type        = string
}

variable "tenant_id" {
  description = "Entra ID (Azure AD) Tenant ID."
  type        = string
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "westeurope"
}

variable "location_short" {
  description = "Short code for the region; used in resource names."
  type        = string
  default     = "weu"
}

variable "project" {
  description = "Project slug used in resource names and tags."
  type        = string
  default     = "devsecopslab"
}

variable "environment" {
  description = "Environment slug used in resource names and tags (dev, stage, prod)."
  type        = string
  default     = "dev"
}

variable "owner_email" {
  description = "Owner contact for the lab; used as the owner tag."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in <owner>/<repo> form. Used as the federated-credential subject prefix."
  type        = string
  default     = "mottbott/devsecops-lab-azure"
}

variable "github_branch" {
  description = "GitHub branch trusted by the federated credential."
  type        = string
  default     = "main"
}

variable "app_service_sku" {
  description = "App Service Plan SKU. B1 = Basic (smallest tier with Always On + custom containers)."
  type        = string
  default     = "B1"
}

variable "log_retention_days" {
  description = "Retention for the Log Analytics workspace, in days."
  type        = number
  default     = 30
}

variable "log_daily_cap_gb" {
  description = "Daily ingestion cap for Log Analytics, in GB. Cost ceiling."
  type        = number
  default     = 1
}

variable "allowed_ingress_ips" {
  description = "Optional list of CIDRs to allow on the App Service. Empty list = no IP restriction."
  type        = list(string)
  default     = []
}

variable "tags_additional" {
  description = "Free-form tags merged into the default tag set."
  type        = map(string)
  default     = {}
}
