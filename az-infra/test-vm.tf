# =========================================================================
# Bastion host and test vm
# =========================================================================
resource "azurerm_bastion_host" "bastion" {
  name                   = "${local.prefix}bastion"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  copy_paste_enabled     = true
  file_copy_enabled      = true
  ip_connect_enabled     = true
  sku                    = var.bastion_sku
  scale_units            = 2
  shareable_link_enabled = false
  tunneling_enabled      = false
  tags                   = local.common_tags

  ip_configuration {
    name                 = "${local.prefix}bastion-conf"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
resource "azurerm_windows_virtual_machine" "test_vm" {
  name                  = "${local.prefix}test-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  computer_name         = var.computer_name
  admin_username        = var.vm_admin
  admin_password        = var.vm_pwd
  network_interface_ids = [azurerm_network_interface.vmnic.id]

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_acc_type
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }
}
# =========================================================================