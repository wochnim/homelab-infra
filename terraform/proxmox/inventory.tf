resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    vm_name = proxmox_virtual_environment_vm.test.name
    vm_ipv4 = one([
      for ip in flatten(proxmox_virtual_environment_vm.test.ipv4_addresses) :
      ip if can(regex("^192\\.168\\.|^10\\.|^172\\.(1[6-9]|2[0-9]|3[0-1])\\.", ip))
    ])
    tags = proxmox_virtual_environment_vm.test.tags
  })

filename = "${path.root}/../../ansible/inventory/hosts.ini"

}

