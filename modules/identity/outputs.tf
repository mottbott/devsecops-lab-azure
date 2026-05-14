output "application_id" {
  description = "Application (client) ID of the GitHub Actions OIDC app registration."
  value       = azuread_application.gh_oidc.client_id
}

output "service_principal_object_id" {
  description = "Object ID of the GitHub Actions OIDC service principal."
  value       = azuread_service_principal.gh_oidc.object_id
}
