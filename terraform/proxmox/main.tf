terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.18.5:8006/api2/json"
  api_token = "terraform@pve!terraform=${var.proxmox_api_token}"

  insecure = true
}

resource "proxmox_virtual_environment_vm" "test" {
  name      = "tf-test-01"
  node_name = "prox"

  clone {
    vm_id = 9000
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }
 
  agent {
   enabled = true
  }

  disk {
    interface = "scsi0"
    size = 8
 }

  network_device {
    bridge = "vmbr0"
  }

  tags = [
   "os_ubuntu",
   "linux",
   "baseline"
  ]

  initialization {
    user_account {
      username = "sysdev"
      keys     = [file("~/.ssh/id_ed25519.pub")]
    }

    ip_config {
      ipv4 {}
    }
  }
}



