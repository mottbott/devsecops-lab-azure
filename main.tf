resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

module "monitoring" {
  source = "./modules/monitoring"

  name                = local.log_analytics_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  retention_in_days   = var.log_retention_days
  daily_quota_gb      = var.log_daily_cap_gb
  tags                = local.tags
}

module "acr" {
  source = "./modules/acr"

  name                       = local.acr_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  log_analytics_workspace_id = module.monitoring.workspace_id
  tags                       = local.tags
}

module "app_service" {
  source = "./modules/app-service"

  app_name                   = local.app_service_name
  plan_name                  = local.app_service_plan_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  app_service_sku            = var.app_service_sku
  log_analytics_workspace_id = module.monitoring.workspace_id
  allowed_ingress_ips        = var.allowed_ingress_ips

  # Two ways to surface a Key Vault secret to the app — both demonstrated:
  #
  #  1. KEY_VAULT_URI (SDK pull): only the vault URI is injected. The app
  #     code uses azure-keyvault-secrets + DefaultAzureCredential to fetch
  #     the secret at runtime (endpoint /config). Educational — the whole
  #     MI -> token -> KV data-plane path is visible in app code. App owns
  #     caching/refresh.
  #
  #  2. DEMO_MESSAGE_VIA_REF (Key Vault Reference): App Service resolves the
  #     @Microsoft.KeyVault(...) reference server-side and injects the secret
  #     VALUE as a plain env var (endpoint /config-ref). No SDK, no KV
  #     knowledge in code. App Service handles refresh (~24h / on restart).
  #     This is the App Service analogue to the AKS Secrets Store CSI driver
  #     file-mount — the platform does the work, the app just reads a value.
  #     Production-preferred for a simple static secret like this.
  #
  # Both are derived from the deterministic vault name, so the app_service
  # module does not depend on the keyvault module (would create a cycle —
  # keyvault needs the App Service MI principal id).
  app_settings_extra = {
    KEY_VAULT_URI        = local.keyvault_uri
    DEMO_MESSAGE_VIA_REF = local.keyvault_demo_secret_ref
  }

  tags = local.tags
}

module "keyvault" {
  source = "./modules/keyvault"

  name                     = local.keyvault_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  app_service_principal_id = module.app_service.principal_id
  deployer_object_id       = data.azurerm_client_config.current.object_id
  demo_secret_name         = local.keyvault_demo_secret_name
  tags                     = local.tags
}

module "identity" {
  source = "./modules/identity"

  display_name             = local.oidc_app_display_name
  github_repository        = var.github_repository
  github_branch            = var.github_branch
  acr_id                   = module.acr.id
  app_service_id           = module.app_service.id
  app_service_principal_id = module.app_service.principal_id
}
