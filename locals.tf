locals {
  name_prefix = "${var.project}-${var.environment}-${var.location_short}"

  resource_group_name   = "rg-${local.name_prefix}"
  app_service_plan_name = "asp-${local.name_prefix}"
  app_service_name      = "app-${local.name_prefix}"
  log_analytics_name    = "log-${local.name_prefix}"

  # Key Vault names: 3-24 chars, alphanumeric + hyphens, globally unique.
  # "kv-devsecopslab-dev-weu" = 23 chars — fits.
  keyvault_name = "kv-${local.name_prefix}"

  keyvault_uri              = "https://${local.keyvault_name}.vault.azure.net/"
  keyvault_demo_secret_name = "demo-message"

  # Key Vault Reference for App Service app settings. App Service resolves
  # this server-side and injects the value as a plain env var. SecretUri
  # without a version pins to "latest".
  keyvault_demo_secret_ref = "@Microsoft.KeyVault(SecretUri=${local.keyvault_uri}secrets/${local.keyvault_demo_secret_name}/)"

  # ACR names must be alphanumeric, lowercase, 5-50 chars — no hyphens.
  acr_name = lower(replace("acr${local.name_prefix}", "-", ""))

  oidc_app_display_name = "gh-oidc-${var.project}-${var.environment}"

  tags = merge(
    {
      environment = var.environment
      project     = var.project
      owner       = var.owner_email
      managed_by  = "terraform"
      cost_center = "lab"
    },
    var.tags_additional,
  )
}
