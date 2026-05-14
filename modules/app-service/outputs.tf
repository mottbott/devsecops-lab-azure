output "id" {
  description = "Resource ID of the App Service; used as scope for the Website Contributor role assignment."
  value       = azurerm_linux_web_app.main.id
}

output "name" {
  description = "Name of the App Service."
  value       = azurerm_linux_web_app.main.name
}

output "default_hostname" {
  description = "Default hostname (e.g. <name>.azurewebsites.net). Used for smoke tests."
  value       = azurerm_linux_web_app.main.default_hostname
}

output "principal_id" {
  description = "Object ID of the App Service's system-assigned managed identity; needs AcrPull on the ACR."
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}
