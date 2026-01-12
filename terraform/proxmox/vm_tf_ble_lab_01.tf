resource "proxmox_virtual_environment_vm" "ble" {
  name      = "ble-lab-01"
  node_name = "prox"
  started = true

  clone {
    vm_id = 9000
  }

  cpu {
    cores = 2
    type = "host"
  }

  memory {
    dedicated = 2048
  }
 
  agent {
   enabled = true
  }

  disk {
    interface = "scsi0"
    size = 16
 }

  network_device {
    bridge = "vmbr0"
  }

  tags = [
   "os_ubuntu",
   "linux",
   "baseline"
  ]
  
  lifecycle {
  ignore_changes = [
    initialization,
   ]
  }

  initialization {
    user_account {
      username = "sysdev"
      keys     = [file("/home/sysdev/.ssh/id_ed25519.pub")]
    }

    ip_config {
      ipv4 {}
    }
  }
}
