variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "region" {
  description = "Droplet region"
  default     = "blr1"
}

variable "vm_name" {
  description = "Droplet name"
  default     = "light-droplet"
}

variable "ssh_public_key" {
  description = "SSH public key path"
  default     = "~/.ssh/id_ed25519_main.pub"
}

variable "vm_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-2vcpu-4gb"
}
