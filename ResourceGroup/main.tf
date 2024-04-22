resource "azurerm_resource_group" "RG" {
  name     = "sonu_rg"
  location = "Central India"
}
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.RG]
  name                = "sonu-vnet"
  location            = "Central India"
  resource_group_name = "sonu_rg"
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = "sonu-subnet"
  resource_group_name  = "sonu_rg"
  virtual_network_name = "sonu-vnet"
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_public_ip" "pip" {
  depends_on          = [azurerm_subnet.subnet]
  name                = "sonu-PublicIp"
  resource_group_name = "sonu_rg"
  location            = "Central India"
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "nic" {
  depends_on          = [azurerm_public_ip.pip]
  name                = "sonu-nic"
  location            = "Central India"
  resource_group_name = "sonu_rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  depends_on                      = [azurerm_network_interface.nic]
  name                            = "sonu-machine"
  resource_group_name             = "sonu_rg"
  location                        = "Central India"
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "sonu@989153"
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
# resource "azurerm_resource_group" "rg_block" {
#   name     = "ratan-rg"
#   location = "West Europe"
# }

# resource "azurerm_virtual_network" "vnet" {
#   depends_on          = [azurerm_resource_group.rg_block]
#   name                = "ratan-vnet"
#   address_space       = ["192.168.1.0/24"]
#   location            = "West Europe"
#   resource_group_name = "ratan-rg"
# }

# resource "azurerm_subnet" "subnet" {
#   depends_on           = [azurerm_virtual_network.vnet]
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = "ratan-rg"
#   virtual_network_name = "ratan-vnet"
#   address_prefixes     = ["192.168.1.224/27"]
# }

# resource "azurerm_public_ip" "pip" {
#   depends_on          = [azurerm_subnet.subnet]
#   name                = "Bastion-pip"
#   location            = "West Europe"
#   resource_group_name = "ratan-rg"
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bastion_host" {
#   depends_on          = [azurerm_public_ip.pip]
#   name                = "ratan-bastion"
#   location            = "West Europe"
#   resource_group_name = "ratan-rg"

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.subnet.id
#     public_ip_address_id = azurerm_public_ip.pip.id
#   }
# }