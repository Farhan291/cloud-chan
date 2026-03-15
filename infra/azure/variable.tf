variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "light-vm-rg"
}

variable "vnet_name" {
  description = "Virutal net name"
  type        = string
  default     = "light-vnet"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "light-subnet"
}

variable "pip_name" {
  description = "Public ip name"
  type        = string
  default     = "light-pip"
}

variable "nic_name" {
  description = "Network interface card name"
  type        = string
  default     = "light-nic"
}

variable "nsg_name" {
  description = "Network Security group name"
  type        = string
  default     = "light-nsg"
}

variable "vm_name" {
  description = "Name of vm"
  type        = string
  default     = "terraform-vm"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1ms"
}

variable "ssh_public_key" {
  description = "SSH public key path"
  type        = string
  default     = "~/.ssh/id_ed25519_main.pub"
}

variable "admin_name" {
  description = "Name of admin"
  type        = string
  default     = "light"
}


