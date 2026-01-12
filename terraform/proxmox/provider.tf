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
