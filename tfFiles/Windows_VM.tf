resource "azurerm_resource_group" "windowsmain" {
  name     = "${var.prefix}-RG"
  location = "West US"
}

resource "azurerm_virtual_network" "windowsmain" {
  name                = "${var.prefix}-VN"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.windowsmain.location
  resource_group_name = azurerm_resource_group.windowsmain.name
}

resource "azurerm_subnet" "windowsinternal" {
  name                 = "windowsinternal"
  resource_group_name  = azurerm_resource_group.windowsmain.name
  virtual_network_name = azurerm_virtual_network.windowsmain.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "windowsmain" {
  name                = "${var.prefix}-NIC"
  location            = azurerm_resource_group.windowsmain.location
  resource_group_name = azurerm_resource_group.windowsmain.name

  ip_configuration {
    name                          = "TestConfiguration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "windowsmain" {
  name                  = "${var.prefix}-Windows-VM"
  location              = azurerm_resource_group.windowsmain.location
  resource_group_name   = azurerm_resource_group.windowsmain.name
  network_interface_ids = [azurerm_network_interface.windowsmain.id]
  vm_size               = "Standard_B2s"
  
  # uncomment this line to delete the os disk automatically when deleting the vm
  delete_os_disk_on_termination = true

  # uncomment this line to delete the data disks automatically when deleting the vm
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "server-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "terraformvm"
    admin_username = "testadmin"
    admin_password = "Aa123456123456Bb"
  }

  os_profile_windows_config {
  }

  tags = {
    environment = "staging"
  }
}