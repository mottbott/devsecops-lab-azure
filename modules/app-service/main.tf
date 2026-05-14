resource "azurerm_service_plan" "main" {
  name                = var.plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.app_service_sku

  tags = var.tags
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only = true

  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                         = true
    minimum_tls_version               = "1.2"
    ftps_state                        = "Disabled"
    health_check_path                 = var.health_check_path
    health_check_eviction_time_in_min = 2

    # App Service pulls images using its system-assigned managed identity.
    # AcrPull role assignment is wired in the identity module.
    container_registry_use_managed_identity = true

    application_stack {
      docker_image_name   = var.bootstrap_image_name
      docker_registry_url = var.bootstrap_image_registry
    }

    dynamic "ip_restriction" {
      for_each = var.allowed_ingress_ips
      content {
        name       = "allow-${ip_restriction.key}"
        ip_address = ip_restriction.value
        action     = "Allow"
        priority   = 100 + ip_restriction.key
      }
    }
  }

  app_settings = merge(
    {
      WEBSITES_PORT                       = tostring(var.container_port)
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    },
    var.app_settings_extra,
  )

  tags = var.tags

  # After the first apply, the CI/CD pipeline (az webapp config container set)
  # owns the docker image reference. Terraform stops re-asserting it to avoid
  # drift on every plan/apply.
  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name,
      site_config[0].application_stack[0].docker_registry_url,
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "app" {
  name                       = "diag-${var.app_name}"
  target_resource_id         = azurerm_linux_web_app.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  enabled_log {
    category = "AppServiceAppLogs"
  }
  enabled_log {
    category = "AppServiceAuditLogs"
  }
  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }
  enabled_log {
    category = "AppServicePlatformLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
