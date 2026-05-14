variable "display_name" {
  description = "Display name of the Entra app registration used by GitHub Actions OIDC."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in <owner>/<repo> form."
  type        = string
}

variable "github_branch" {
  description = "GitHub branch trusted by the federated credential."
  type        = string
  default     = "main"
}

variable "acr_id" {
  description = "Resource ID of the ACR; scope for AcrPush and AcrPull role assignments."
  type        = string
}

variable "app_service_id" {
  description = "Resource ID of the App Service; scope for the Website Contributor role assignment."
  type        = string
}

variable "app_service_principal_id" {
  description = "Object ID of the App Service system-assigned managed identity; gets AcrPull on the ACR."
  type        = string
}
