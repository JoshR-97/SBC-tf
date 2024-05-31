/*# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "azurerm_managed_disk" "sbc1" {
  create_option                 = "FromImage"
  disk_access_id                = null
  disk_encryption_set_id        = null
  disk_iops_read_only           = 0
  disk_iops_read_write          = 120
  disk_mbps_read_only           = 0
  disk_mbps_read_write          = 25
  disk_size_gb                  = 4
  edge_zone                     = null
  gallery_image_reference_id    = null
  hyper_v_generation            = null
  image_reference_id            = "/Subscriptions/abc123/Providers/Microsoft.Compute/Locations/uksouth/Publishers/ribboncommunications/ArtifactTypes/VMImage/Offers/ribbon_sbc_swe-lite_vm/Skus/ribbon_sbc_swe-lite_vm_release/Versions/12.120001.075"
  location                      = "uksouth"
  logical_sector_size           = null
  max_shares                    = 0
  name                          = "vm-sbc-uks-001_lun_0_2_7df39a75d41941918a30eabb9d550981"
  network_access_policy         = null
  on_demand_bursting_enabled    = false
  os_type                       = null
  public_network_access_enabled = true
  resource_group_name           = "SBC"
  source_resource_id            = null
  source_uri                    = null
  storage_account_id            = null
  storage_account_type          = "Premium_LRS"
  tags                          = {}
  tier                          = "P1"
  trusted_launch_enabled        = false
  zone                          = jsonencode(1)
  timeouts {
    create = null
    delete = null
    read   = null
    update = null
  }
}

# __generated__ by Terraform
resource "azurerm_linux_virtual_machine" "sbc1" {
  admin_password                  = null # sensitive
  admin_username                  = "azureuser"
  allow_extension_operations      = true
  availability_set_id             = null
  computer_name                   = "vm-sbc-uks-001"
  custom_data                     = null # sensitive
  dedicated_host_group_id         = null
  dedicated_host_id               = null
  disable_password_authentication = true
  edge_zone                       = null
  encryption_at_host_enabled      = false
  eviction_policy                 = null
  extensions_time_budget          = "PT1H30M"
  license_type                    = null
  location                        = "uksouth"
  max_bid_price                   = -1
  name                            = "vm-sbc-uks-001"
  network_interface_ids           = ["/subscriptions/abc123/resourceGroups/SBC/providers/Microsoft.Network/networkInterfaces/nic-sbc-uks-001", "/subscriptions/abc123/resourceGroups/SBC/providers/Microsoft.Network/networkInterfaces/nic-sbc-uks-002", "/subscriptions/abc123/resourceGroups/SBC/providers/Microsoft.Network/networkInterfaces/nic-sbc-uks-003"]
  patch_mode                      = "ImageDefault"
  platform_fault_domain           = -1
  priority                        = "Regular"
  provision_vm_agent              = true
  proximity_placement_group_id    = null
  resource_group_name             = "SBC"
  secure_boot_enabled             = false
  size                            = "Standard_B2s"
  source_image_id                 = null
  tags                            = {}
  user_data                       = null
  virtual_machine_scale_set_id    = null
  vtpm_enabled                    = false
  zone                            = jsonencode(1)
  additional_capabilities {
    ultra_ssd_enabled = false
  }
  admin_ssh_key {
    public_key = "abc123"
    username   = "azureuser"
  }
  boot_diagnostics {
    storage_account_uri = null
  }
  os_disk {
    caching                   = "ReadWrite"
    disk_encryption_set_id    = null
    disk_size_gb              = 1
    name                      = "vm-sbc-uks-001_OsDisk_1_36ed98522f35446e9b355543edabd4d3"
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
  timeouts {
    create = null
    delete = null
    read   = null
    update = null
  }
}
*/