resource "azurerm_resource_group" "SBCrg" {
  name     = "SBC"
  location = "uksouth"
}

resource "azurerm_virtual_network" "sbc" {
  name                = "vnet-sbc-uks-001"
  address_space       = ["10.10.10.0/23"]
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name
}

resource "azurerm_subnet" "web_subnet" {
  name                 = "sn-sbc-uks-001"
  resource_group_name  = azurerm_resource_group.SBCrg.name
  virtual_network_name = azurerm_virtual_network.sbc.name
  address_prefixes     = ["10.10.10.0/29"]
  depends_on = [ 
    azurerm_virtual_network.sbc
   ]
}

resource "azurerm_subnet" "media_subnet" {
  name                 = "sn-sbc-uks-002"
  resource_group_name  = azurerm_resource_group.SBCrg.name
  virtual_network_name = azurerm_virtual_network.sbc.name
  address_prefixes     = ["10.10.10.8/29"]
  depends_on = [ 
    azurerm_virtual_network.sbc
   ]
}

resource "azurerm_subnet" "provider_subnet" {
  name                 = "sn-sbc-uks-003"
  resource_group_name  = azurerm_resource_group.SBCrg.name
  virtual_network_name = azurerm_virtual_network.sbc.name
  address_prefixes     = ["10.10.10.16/29"]
  depends_on = [ 
    azurerm_virtual_network.sbc
   ]
}

# Create Network Security Group and **rules tbc at a later date**
resource "azurerm_network_security_group" "sbc" {
  name                = "nsg-sbc-uks-001"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name

  depends_on = [ 
    azurerm_virtual_network.sbc
   ]
}

resource "azurerm_public_ip" "web_public_ip" {
  name                = "pip-sbc-uks-001"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "media_public_ip" {
  name                = "pip-sbc-uks-002"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "provider_public_ip" {
  name                = "pip-sbc-uks-003"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create network interface
resource "azurerm_network_interface" "web_nic" {
  name                = "nic-sbc-uks-001"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name

  ip_configuration {
    name                          = "ip-sbc-uks-001"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_public_ip.id
  }
  depends_on = [ 
    azurerm_public_ip.web_public_ip
   ]
}

# Create network interface
resource "azurerm_network_interface" "media_nic" {
  name                = "nic-sbc-uks-002"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name

  ip_configuration {
    name                          = "ip-sbc-uks-002"
    subnet_id                     = azurerm_subnet.media_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.media_public_ip.id
  }
  depends_on = [ 
    azurerm_public_ip.media_public_ip
   ]
}

# Create network interface
resource "azurerm_network_interface" "provider_nic" {
  name                = "nic-sbc-uks-003"
  location            = azurerm_resource_group.SBCrg.location
  resource_group_name = azurerm_resource_group.SBCrg.name

  ip_configuration {
    name                          = "ip-sbc-uks-003"
    subnet_id                     = azurerm_subnet.provider_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.provider_public_ip.id
  }
  depends_on = [ 
    azurerm_public_ip.provider_public_ip 
    ]
}

# Create (and eventually display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Required to accept publisher legal terms
resource "azurerm_marketplace_agreement" "ribbon" {
  publisher = "ribboncommunications"
  offer     = "ribbon_sbc_swe-lite_vm"
  plan      = "ribbon_sbc_swe-lite_vm_release"
}

# Create VM
resource "azurerm_linux_virtual_machine" "sbc" {
  admin_password                  = null # sensitive
  admin_username                  = "azureuser"
  allow_extension_operations      = true
  computer_name                   = "vm-sbc-uks-001"
  custom_data                     = null # sensitive
  disable_password_authentication = true
  encryption_at_host_enabled      = false
  extensions_time_budget          = "PT1H30M"
  location                        = "uksouth"
  max_bid_price                   = -1
  name                            = "vm-sbc-uks-001"
  network_interface_ids = [
    azurerm_network_interface.media_nic.id,
    azurerm_network_interface.web_nic.id,
    azurerm_network_interface.provider_nic.id
  ]
  patch_mode                      = "ImageDefault"
  priority                        = "Regular"
  provision_vm_agent              = true
  resource_group_name             = "SBC"
  secure_boot_enabled             = false
  size                            = "Standard_B2s"
  tags                            = {}
  vtpm_enabled                    = false
  zone                            = jsonencode(1)
  additional_capabilities {
    ultra_ssd_enabled = false
  }
  admin_ssh_key {
    public_key = tls_private_key.example_ssh.public_key_openssh
    username   = "azureuser"
  }
  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = 1
    name                      = "vm-sbc-uks-001_OsDisk_1"
    storage_account_type      = "Premium_LRS"
    write_accelerator_enabled = false
  }
  plan {
    name      = "ribbon_sbc_swe-lite_vm_release"
    product   = "ribbon_sbc_swe-lite_vm"
    publisher = "ribboncommunications"
  }
  source_image_reference {
    offer     = "ribbon_sbc_swe-lite_vm"
    publisher = "ribboncommunications"
    sku       = "ribbon_sbc_swe-lite_vm_release"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "data_disk" {
  name                 = "data-disk-sbc"
  location             = azurerm_resource_group.SBCrg.location
  resource_group_name  = azurerm_resource_group.SBCrg.name
  storage_account_type = "Premium_LRS"
  create_option        = "FromImage"
  image_reference_id   = "/Subscriptions/abc123/Providers/Microsoft.Compute/Locations/uksouth/Publishers/ribboncommunications/ArtifactTypes/VMImage/Offers/ribbon_sbc_swe-lite_vm/Skus/ribbon_sbc_swe-lite_vm_release/Versions/12.120001.075"
  disk_size_gb         = 4
  os_type              = "Linux"
}

resource "azurerm_virtual_machine_data_disk_attachment" "sbc_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.sbc.id
  lun                = "0"
  caching            = "None"
}


/*
#### Import ####
import {
  id = "/subscriptions/abc123/resourceGroups/SBC/providers/Microsoft.Compute/virtualMachines/vm-sbc-uks-001"
  to = azurerm_linux_virtual_machine.sbc1
}

import {
  id = "/subscriptions/abc123/resourceGroups/SBC/providers/Microsoft.Compute/disks/vm-sbc-uks-001_lun_0_2_7df39a75d41941918a30eabb9d550981"
  to = azurerm_managed_disk.sbc1
}
*/ 
output "ssh_public_key" {
  value = tls_private_key.example_ssh.public_key_openssh
}
