locals {
  name_prefix = "${var.project}-${var.environment}-${var.location_short}"

  resource_group_name   = "rg-${local.name_prefix}"
  app_service_plan_name = "asp-${local.name_prefix}"
  app_service_name      = "app-${local.name_prefix}"
  log_analytics_name    = "log-${local.name_prefix}"

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
