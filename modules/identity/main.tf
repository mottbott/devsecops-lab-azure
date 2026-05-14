data "azuread_client_config" "current" {}

resource "azuread_application" "gh_oidc" {
  display_name     = var.display_name
  sign_in_audience = "AzureADMyOrg"
  owners           = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "gh_oidc" {
  client_id = azuread_application.gh_oidc.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_federated_identity_credential" "github_main" {
  application_id = azuread_application.gh_oidc.id
  display_name   = "github-${var.github_branch}"
  description    = "GitHub Actions OIDC for ${var.github_repository}@${var.github_branch}"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repository}:ref:refs/heads/${var.github_branch}"
  audiences      = ["api://AzureADTokenExchange"]
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.gh_oidc.object_id
  description          = "Allow GitHub Actions OIDC SP to push images to ACR."
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.app_service_principal_id
  description          = "Allow App Service managed identity to pull images from ACR."
}

resource "azurerm_role_assignment" "website_contributor" {
  scope                = var.app_service_id
  role_definition_name = "Website Contributor"
  principal_id         = azuread_service_principal.gh_oidc.object_id
  description          = "Allow GitHub Actions OIDC SP to update the App Service container image."
}
