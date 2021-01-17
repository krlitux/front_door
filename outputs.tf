output "azfd_id" {
  description = "Id del recurso desplegado"
  value       = azurerm_frontdoor.azfd.id
}

output "azfd_frontend" {
  description = "Hostname configurado en frontdoor"
  value       = azurerm_frontdoor.azfd.frontend_endpoint[0].host_name
}
