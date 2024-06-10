# =========================================================================
# Azure Bastion nsg and inbound rules
# =========================================================================
resource "azurerm_network_security_group" "bastion_subnet_nsg" {
  name                = "${local.prefix}bastion-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
}
resource "azurerm_network_security_rule" "https_to_bastion" {
  name                        = "AllowHttpsInbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = chomp(data.http.my_ipaddr.response_body)
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_network_security_rule" "bastion_gw_manager" {
  name                        = "AllowGatewayManagerInbound"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_network_security_rule" "bastion_lb" {
  name                        = "AllowAzureLoadBalancerIbound"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_network_security_rule" "bastion_data_plane" {
  name                        = "AllowBastionHostCommunication"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["5701", "8080"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
# =========================================================================
# Azure Bastion egress rules and NSG bastion subnet association
# =========================================================================
resource "azurerm_network_security_rule" "ssh_rdp_to_target_vms_outbound" {
  name                        = "AllowSshRdpOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["3389", "22"]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_network_security_rule" "bastion_azcloud_egress_outbound" {
  name                        = "AzureCloudOutboundAllow"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_network_security_rule" "bastion_data_plane_outbound" {
  name                        = "AllowBastionCommunication"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = ["5701", "8080"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_network_security_rule" "bastion_session_info_outbound" {
  name                        = "AllowHttpOutbound"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
  depends_on                  = [azurerm_bastion_host.bastion]
}
resource "azurerm_subnet_network_security_group_association" "bastion_snet_assoc" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion_subnet_nsg.id
}
# =========================================================================