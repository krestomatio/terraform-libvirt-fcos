resource "libvirt_volume" "root" {
  name             = var.root_volume_format != "" ? "${local.hostname}-root.${var.root_volume_format}" : "${local.hostname}-root"
  pool             = var.root_volume_pool
  size             = var.root_volume_size
  base_volume_name = var.root_base_volume_name
  base_volume_pool = var.root_base_volume_pool

  lifecycle {
    ignore_changes = [
      # https://github.com/dmacvicar/terraform-provider-libvirt/issues/952
      size
    ]
  }
}

resource "libvirt_volume" "log" {
  count = var.log_volume ? 1 : 0

  name = var.log_volume_format != "" ? "${local.hostname}-log.${var.log_volume_format}" : "${local.hostname}-log"
  pool = var.log_volume_pool
  size = var.log_volume_size

  lifecycle {
    ignore_changes = [
      # https://github.com/dmacvicar/terraform-provider-libvirt/issues/952
      size
    ]
  }
}

resource "libvirt_volume" "data" {
  count = var.data_volume ? 1 : 0

  name = var.data_volume_format != "" ? "${local.hostname}-data.${var.data_volume_format}" : "${local.hostname}-data"
  pool = var.data_volume_pool
  size = var.data_volume_size
  lifecycle {
    ignore_changes = [
      # https://github.com/dmacvicar/terraform-provider-libvirt/issues/952
      size
    ]
  }
}

resource "libvirt_volume" "backup" {
  count = var.backup_volume ? 1 : 0

  name = var.backup_volume_format != "" ? "${local.hostname}-backup.${var.backup_volume_format}" : "${local.hostname}-backup"
  pool = var.backup_volume_pool
  size = var.backup_volume_size

  lifecycle {
    ignore_changes = [
      # https://github.com/dmacvicar/terraform-provider-libvirt/issues/952
      size
    ]
  }
}

resource "libvirt_ignition" "node" {
  name    = "${local.hostname}.ign"
  pool    = var.ignition_pool
  content = data.ct_config.node.rendered
}

resource "libvirt_domain" "node" {
  depends_on = [libvirt_volume.root]

  name       = local.hostname
  memory     = var.memory
  vcpu       = var.vcpu
  qemu_agent = var.qemu_agent
  autostart  = var.autostart

  arch     = var.arch
  cmdline  = var.cmdline
  emulator = var.emulator
  machine  = var.machine
  firmware = var.firmware

  dynamic "nvram" {
    for_each = var.nvram != null ? [1] : []
    content {
      file     = var.nvram.file
      template = var.nvram.template
    }
  }

  # fw_cfg_name     = "opt/com.coreos/config"
  coreos_ignition = libvirt_ignition.node.id

  cpu {
    mode = var.cpu_mode
  }

  disk {
    volume_id = libvirt_volume.root.id
  }

  dynamic "disk" {
    for_each = local.libvirt_domain_additional_disks
    content {
      volume_id = disk.value.volume_id
    }
  }

  network_interface {
    hostname       = local.hostname
    bridge         = var.network_bridge
    network_name   = var.network_name
    network_id     = var.network_id
    addresses      = var.cidr_ip_address != null ? [split("/", var.cidr_ip_address)[0]] : null
    mac            = var.mac
    wait_for_lease = var.wait_for_lease
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  xml {
    xslt = local.xslt
  }

  lifecycle {
    replace_triggered_by = [
      libvirt_volume.root.id
    ]
    ignore_changes = [
      # TODO: investigate why firmware and nvram are not being applied in aarch64
      firmware,
      nvram,
      # Avoid replacement on ignore changes since shutdown is not managed properly.
      # Implementation of https://github.com/dmacvicar/terraform-provider-libvirt/issues/356 could avoid doing this
      # Manual replacement recommended to handle shutdown and order properly
      coreos_ignition
    ]
  }
}
