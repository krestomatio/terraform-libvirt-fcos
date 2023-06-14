module "butane_common_snippets" {
  source  = "krestomatio/butane-snippets/ct//modules/common"
  version = "0.0.33"

  hostname            = var.fqdn
  ssh_authorized_key  = var.ssh_authorized_key
  nameservers         = var.nameservers
  timezone            = var.timezone
  interface_name      = var.interface_name
  keymap              = var.keymap
  rollout_wariness    = var.rollout_wariness
  periodic_updates    = var.periodic_updates
  cidr_ip_address     = var.cidr_ip_address
  etc_hosts           = var.etc_hosts
  etc_hosts_extra     = var.etc_hosts_extra
  disks               = local.default_storage.disks
  filesystems         = local.default_storage.filesystems
  additional_rpms     = local.additional_rpms
  systemd_pager       = var.systemd_pager
  sysctl              = var.sysctl
  sync_time_with_host = var.sync_time_with_host
  do_not_countme      = var.do_not_countme
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
