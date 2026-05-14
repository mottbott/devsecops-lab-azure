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
  tags                       = local.tags
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
