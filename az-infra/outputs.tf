# =========================================================================
# Post-deployment nslookup command and app service URL
# =========================================================================
output "webapp_url" {
  description = "output URL to deploy into test vm edge browser"
  value       = azurerm_linux_web_app.webapp.default_hostname
}
output "wapp_ns_query" {
  value = "nslookup ${azurerm_linux_web_app.webapp.default_hostname}"
}
# =========================================================================