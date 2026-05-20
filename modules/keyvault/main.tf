resource "azurerm_key_vault" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  # RBAC data-plane authorization (modern path) instead of legacy access policies.
  rbac_authorization_enabled = true

  # Phase 0: no purge protection. Purge protection would block a clean
  # `terraform destroy` (7-90 day name lock) — conflicts with the cleanup
  # discipline. Accepted, documented as a Checkov skip.
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  # Phase 0: public endpoint + firewall default-allow, like ACR/App Service.
  public_network_access_enabled = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# The principal running `terraform apply` needs data-plane write to seed the
# demo secret (RBAC mode does not grant data access via management roles).
resource "azurerm_role_assignment" "deployer_secrets_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.deployer_object_id
  description          = "Allow the apply principal to write the demo secret."
}

# App Service system-assigned MI: read-only secret access.
resource "azurerm_role_assignment" "app_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.app_service_principal_id
  description          = "Allow the App Service managed identity to read secrets."
}

# RBAC role assignments take time to propagate to the data plane. Without a
# wait, the first apply often fails creating the secret with a 403.
resource "time_sleep" "wait_for_rbac" {
  depends_on      = [azurerm_role_assignment.deployer_secrets_officer]
  create_duration = "60s"
}

resource "azurerm_key_vault_secret" "demo" {
  name         = var.demo_secret_name
  value        = var.demo_secret_value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [time_sleep.wait_for_rbac]
}
