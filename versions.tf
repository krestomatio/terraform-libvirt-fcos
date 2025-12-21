terraform {
  required_version = ">= 1.2.0"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.11.0"
    }
  }
}
