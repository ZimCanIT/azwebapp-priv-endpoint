# =========================================================================
# Vnet & subnets
# =========================================================================
resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_addr
}
# azure bastion subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_snet_cidr
}
# private endpoint subnet 
resource "azurerm_subnet" "priv_endpoint_snet" {
  name                              = "priv-endpoint-snet"
  resource_group_name               = azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.priv_endpoint_snet_cidr
  private_endpoint_network_policies = var.priv_endpoint_policies
}
# =========================================================================
# Private DNS zone: privatelink.azurewebsites.net 
# =========================================================================
resource "azurerm_private_dns_zone" "priv_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "${local.prefix}dnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.priv_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
}
# =========================================================================
# WebApp private endpoint
# =========================================================================
resource "azurerm_private_endpoint" "priv_endpoint" {
  name                = "${local.prefix}privendpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.priv_endpoint_snet.id

  private_service_connection {
    name                           = "${local.prefix}-endpoint-conn"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    is_manual_connection           = false
    subresource_names              = var.subresource
  }

  private_dns_zone_group {
    name                 = "${local.prefix}dns-zone-goroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.priv_dns_zone.id]
  }
}
# =========================================================================
# Bastion public ip and test-vm NIC
# =========================================================================
resource "azurerm_public_ip" "bastion_pip" {
  name                = "${local.prefix}vmpip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = var.pip_alloc
  sku                 = var.bastion_pip_sku
}
resource "azurerm_network_interface" "vmnic" {
  name                = "${local.prefix}vmnic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${local.prefix}ipconf"
    subnet_id                     = azurerm_subnet.priv_endpoint_snet.id
    private_ip_address_allocation = var.pip_alloc
    private_ip_address_version    = var.pip_version
    private_ip_address            = var.private_ip
  }
}
# =========================================================================