locals {
  vms = {
    test     = proxmox_virtual_environment_vm.test
    ble      = proxmox_virtual_environment_vm.ble
    grafana  = proxmox_virtual_environment_vm.grafana
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    vms = {
      for name, vm in local.vms :
      name => {
        name = vm.name
        ipv4 = try(
          one([
            for ip in flatten(vm.ipv4_addresses) :
            ip if can(regex(
              "^192\\.168\\.|^10\\.|^172\\.(1[6-9]|2[0-9]|3[0-1])\\.",
              ip
            ))
          ]),
          ""
        )
        tags = vm.tags
      }
    }
  })

  filename = "${path.root}/../../ansible/inventory/hosts.ini"
}
