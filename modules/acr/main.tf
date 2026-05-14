resource "azurerm_container_registry" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku           = "Basic"
  admin_enabled = false

  # Phase 0: public network access, no Private Endpoints. See architecture.md §12.
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "acr" {
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_container_registry.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
