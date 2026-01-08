output "vm_name" {
  value = proxmox_virtual_environment_vm.test.name
}

output "vm_ipv4" {
  value = try(
    one([
      for ip in flatten(proxmox_virtual_environment_vm.test.ipv4_addresses) :
      ip
      if can(regex("^192\\.168\\.|^10\\.|^172\\.(1[6-9]|2[0-9]|3[0-1])\\.", ip))
    ]),
    null
  )
}
