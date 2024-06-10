# =========================================================================
# Web app service plan, web app and source control
# =========================================================================
resource "azurerm_service_plan" "srv_plan" {
  name                = "${local.prefix}service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.webapp_sku
  os_type             = var.os_type
  tags                = local.common_tags
}
resource "azurerm_linux_web_app" "webapp" {
  name                          = "${local.prefix}zcit2k24"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.srv_plan.id
  https_only                    = true
  public_network_access_enabled = false

  site_config {
    minimum_tls_version = var.tls_version
    always_on           = true
  }
}
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id                 = azurerm_linux_web_app.webapp.id
  repo_url               = var.webapp_repo_url
  branch                 = var.webapp_repo_branch
  use_manual_integration = true
  use_mercurial          = false
}
# =========================================================================