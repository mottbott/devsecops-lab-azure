output "vault_uri" {
  description = "Key Vault URI (https://<name>.vault.azure.net/). The app reads secrets from here."
  value       = azurerm_key_vault.main.vault_uri
}

output "vault_name" {
  description = "Key Vault name."
  value       = azurerm_key_vault.main.name
}

output "demo_secret_name" {
  description = "Name of the seeded demo secret."
  value       = azurerm_key_vault_secret.demo.name
}
