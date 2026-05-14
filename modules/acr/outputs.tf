output "id" {
  description = "Resource ID of the ACR; used as scope for role assignments."
  value       = azurerm_container_registry.main.id
}

output "name" {
  description = "Name of the ACR."
  value       = azurerm_container_registry.main.name
}

output "login_server" {
  description = "Fully qualified login server for the ACR (e.g. acrname.azurecr.io)."
  value       = azurerm_container_registry.main.login_server
}
