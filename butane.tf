module "butane_common_snippets" {
  source  = "krestomatio/butane-snippets/ct//modules/common"
  version = "0.0.2"

  hostname                = var.fqdn
  ssh_authorized_key      = var.ssh_authorized_key
  nameservers             = var.nameservers
  timezone                = var.timezone
  keymap                  = var.keymap
  rollout_wariness        = var.rollout_wariness
  updates_periodic_window = var.updates_periodic_window
  cidr_ip_address         = var.cidr_ip_address
  etc_hosts               = var.etc_hosts
  disks                   = local.storage.disks
  filesystems             = local.storage.filesystems
  additional_rpms         = local.os_additional_rpms
  systemd_pager           = var.systemd_pager
  sync_time_with_host     = var.sync_time_with_host
  do_not_countme          = var.do_not_countme
}

data "ct_config" "node" {
  strict       = true
  pretty_print = true

  content = <<-TEMPLATE
    ---
    variant: fcos
    version: 1.4.0
  TEMPLATE

  snippets = local.butane_snippets
}
