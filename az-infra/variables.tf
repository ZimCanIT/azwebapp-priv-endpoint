variable "rg_location" {
  type    = string
  default = "westeurope"
}
# =========================================================================
# Network
# =========================================================================
variable "vnet_addr" {
  type    = list(string)
  default = ["10.35.0.0/16"]
}
variable "bastion_snet_cidr" {
  type    = list(string)
  default = ["10.35.5.0/26"]
}
variable "priv_endpoint_snet_cidr" {
  type    = list(string)
  default = ["10.35.0.0/26"]
}
variable "subresource" {
  type    = list(string)
  default = ["sites"]
}
variable "priv_endpoint_policies" {
  type    = string
  default = "Disabled"
}
# =========================================================================
# Bastion and virtual machine 
# =========================================================================
variable "bastion_sku" {
  type    = string
  default = "Standard"
}
variable "pip_alloc" {
  type    = string
  default = "Static"
}
variable "pip_version" {
  type    = string
  default = "IPv4"
}
variable "private_ip" {
  type    = string
  default = "10.35.0.60"
}
variable "bastion_pip_sku" {
  type    = string
  default = "Standard"
}
variable "computer_name" {
  type    = string
  default = "bastionvm"
}
variable "vm_size" {
  type    = string
  default = "Standard_B4ms"
}
variable "vm_admin" {
  type        = string
  description = "Admin username for test vm connected to via Azure Bastion"
}
variable "vm_pwd" {
  type        = string
  sensitive   = true
  description = "Admin password for test vm connected to via Azure Bastion"
}
variable "os_disk_caching" {
  type    = string
  default = "ReadWrite"
}
variable "os_disk_storage_acc_type" {
  type    = string
  default = "Standard_LRS"
}
variable "vm_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}
variable "vm_offer" {
  type    = string
  default = "WindowsServer"
}
variable "vm_sku" {
  type    = string
  default = "2022-Datacenter"
}
variable "vm_version" {
  type    = string
  default = "latest"
}
# =========================================================================
# Web app
# =========================================================================
variable "webapp_sku" {
  type    = string
  default = "P1v2"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "tls_version" {
  type    = string
  default = "1.2"
}
variable "webapp_repo_url" {
  type        = string
  description = "The URL of the hello world public repo."
  default     = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
}
variable "webapp_repo_branch" {
  type    = string
  default = "master"
}
# =========================================================================
# Locals
# =========================================================================
locals {
  prefix = "priv-webapp-"
  common_tags = {
    lab         = "web-app-private-endpoint"
    environment = "dev"
    owner       = "jmhpe"
  }
}
# =========================================================================
