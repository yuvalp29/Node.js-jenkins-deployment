resource "azurerm_resource_group" "Linuxmain" {
  name     = "${var.prefix}-RG"
  location = "West US"
}

resource "azurerm_virtual_network" "Linuxmain" {
  name                = "${var.prefix}-VN"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Linuxmain.location
  resource_group_name = azurerm_resource_group.Linuxmain.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Linuxmain.name
  virtual_network_name = azurerm_virtual_network.Linuxmain.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "Linuxmain" {
  name                = "${var.prefix}-NIC"
  location            = azurerm_resource_group.Linuxmain.location
  resource_group_name = azurerm_resource_group.Linuxmain.name

  ip_configuration {
    name                          = "TestConfiguration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "Linuxmain" {
  name                  = "${var.prefix}-Ubuntu-VM"
  location              = azurerm_resource_group.Linuxmain.location
  resource_group_name   = azurerm_resource_group.Linuxmain.name
  network_interface_ids = [azurerm_network_interface.Linuxmain.id]
  vm_size               = "Standard_B2s"

  # uncomment this line to delete the os disk automatically when deleting the vm
  delete_os_disk_on_termination = true

  # uncomment this line to delete the data disks automatically when deleting the vm
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntuserver"
    sku       = "16.04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "readwrite"
    create_option     = "fromimage"
    managed_disk_type = "standard_lrs"
  }

  os_profile {
    computer_name  = "terraformvm"
    admin_username = "testadmin"
    admin_password = "Aa123456123456Bb"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  tags = {
    environment = "terraform"
  }
}