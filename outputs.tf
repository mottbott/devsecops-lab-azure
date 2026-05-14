data "azurerm_client_config" "current" {}

output "azure_tenant_id" {
  description = "Entra tenant ID. Use as GitHub Secret AZURE_TENANT_ID."
  value       = data.azurerm_client_config.current.tenant_id
}

output "azure_subscription_id" {
  description = "Azure subscription ID. Use as GitHub Secret AZURE_SUBSCRIPTION_ID."
  value       = data.azurerm_client_config.current.subscription_id
}

output "azure_client_id" {
  description = "Application (client) ID of the GitHub Actions OIDC app registration. Use as GitHub Secret AZURE_CLIENT_ID."
  value       = module.identity.application_id
  sensitive   = true
}

output "acr_login_server" {
  description = "ACR login server (e.g. <name>.azurecr.io). Use as GitHub Secret ACR_LOGIN_SERVER."
  value       = module.acr.login_server
}

output "azure_app_service_name" {
  description = "App Service name. Use as GitHub Secret AZURE_APP_SERVICE_NAME."
  value       = module.app_service.name
}

output "azure_resource_group" {
  description = "Resource group name. Use as GitHub Secret AZURE_RESOURCE_GROUP."
  value       = azurerm_resource_group.main.name
}

output "azure_app_service_default_hostname" {
  description = "Default hostname of the App Service. Used for smoke tests."
  value       = module.app_service.default_hostname
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace. Useful for ad-hoc KQL queries from the Portal."
  value       = module.monitoring.workspace_id
}
