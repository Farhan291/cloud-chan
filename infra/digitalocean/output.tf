
output "vm_public_ip" {
  value = digitalocean_droplet.vm.ipv4_address
}
