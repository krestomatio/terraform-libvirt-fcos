data "template_file" "butane_snippet_core_authorized_key" {
  template = <<-TEMPLATE
    ---
    variant: fcos
    version: 1.4.0
    passwd:
      users:
        - name: kio
          groups:
          - wheel
          - sudo
          password_hash: $y$j9T$aN.rJonQXE23KzBd/pH5l1$WFNOqADYmKxmcm8wE1MvDcQnm51L4UHamWw2WuO4lD4
  TEMPLATE
}

######################### values #########################
locals {
  # module
  fqdn            = "server.example.com"
  cidr_ip_address = "10.10.14.12/24"
  mac             = "50:50:10:10:14:12"
  machine         = "virt"
  firmware        = "/usr/share/AAVMF/AAVMF_CODE.fd"
  nvram = {
    file     = "/var/lib/libvirt/qemu/nvram/${local.fqdn}_VARS.fd"
    template = "/usr/share/AAVMF/AAVMF_VARS.fd"
  }
  butane_snippets_additional = [data.template_file.butane_snippet_core_authorized_key.rendered]
  interface_name             = "enp1s0"
  vcpu                       = 4
  memory                     = 4096
  root_volume_size           = 1024 * 1024 * 1024 * 10 # in bytes, 10 Gi
  log_volume_size            = 1024 * 1024 * 1024 * 5  # in bytes, 5 Gi
  data_volume_size           = 1024 * 1024 * 1024 * 10 # in bytes, 10 Gi
  backup_volume_size         = 1024 * 1024 * 1024 * 10 # in bytes, 10 Gi
  sync_time_with_host        = false
  qemu_agent                 = true
  systemd_pager              = "cat"
  sysctl = {
    "net.core.somaxconn" = "32768"
  }
  ssh_authorized_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  nameservers        = ["8.8.8.8"]
  timezone           = "America/Costa_Rica"
  do_not_countme     = true
  keymap             = "latam"
  rollout_wariness   = "0.5"
  additional_rpms = {
    list = ["nano"]
  }
  periodic_updates = {
    time_zone = "localtime"
    windows = [
      {
        days           = ["Sat"],
        start_time     = "23:30",
        length_minutes = "60"
      },
      {
        days           = ["Sun"],
        start_time     = "00:30",
        length_minutes = "60"
      }
    ]
  }
  etc_hosts = [
    {
      ip       = "127.0.0.1"
      hostname = "server-01"
      fqdn     = "server-01.example.com"
    },
    {
      ip       = "192.168.0.10"
      hostname = "other-server-01"
      fqdn     = "other-server-01.example.com"
    }
  ]

  # network
  net_cidr_ipv4 = "10.10.14.0/24"
  net_cidr_ipv6 = "2001:db8:ca2:14::/64"

  # image
  fcos_image_version   = "38.20230414.3.0"
  fcos_image_arch      = "aarch64"
  fcos_image_stream    = "stable"
  fcos_image_sha256sum = "5d1f86a8e240fce7edee3a4fddd4d78fad76ed0f9e84f1a9d6c734ad1750ffa0"
  fcos_image_url       = "https://builds.coreos.fedoraproject.org/prod/streams/${local.fcos_image_stream}/builds/${local.fcos_image_version}/${local.fcos_image_arch}/fedora-coreos-${local.fcos_image_version}-qemu.${local.fcos_image_arch}.qcow2.xz"
  fcos_image_name      = "fcos-${local.fcos_image_stream}-${local.fcos_image_version}-${local.fcos_image_arch}.qcow2"
}

# network
resource "libvirt_network" "libvirt_fcos_base" {
  name      = "libvirt-fcos-base"
  mode      = "nat"
  domain    = "cluster.local"
  addresses = ["10.10.14.0/24", "2001:db8:ca2:4::/64"]
}

# image
resource "null_resource" "fcos_image_download" {
  provisioner "local-exec" {
    command = <<-TEMPLATE
      pushd /tmp
      if [ ! -f "${local.fcos_image_name}" ]; then
        curl -L "${local.fcos_image_url}" -o "${local.fcos_image_name}.xz"
        echo "${local.fcos_image_sha256sum} ${local.fcos_image_name}.xz" | sha256sum -c
        unxz "${local.fcos_image_name}.xz"
      fi
      popd
    TEMPLATE
  }
}

resource "libvirt_volume" "fcos_image" {
  depends_on = [null_resource.fcos_image_download]

  name   = "terraform-libvirt-fcos-example-base-${local.fcos_image_name}"
  source = "/tmp/${local.fcos_image_name}"
}

######################## module #########################
module "libvirt_fcos_base" {
  depends_on = [libvirt_volume.fcos_image]

  source = "../.."

  fqdn                       = local.fqdn
  cidr_ip_address            = local.cidr_ip_address
  mac                        = local.mac
  machine                    = local.machine
  firmware                   = local.firmware
  nvram                      = local.nvram
  butane_snippets_additional = local.butane_snippets_additional
  interface_name             = local.interface_name
  qemu_agent                 = local.qemu_agent
  systemd_pager              = local.systemd_pager
  sysctl                     = local.sysctl
  ssh_authorized_key         = local.ssh_authorized_key
  nameservers                = local.nameservers
  timezone                   = local.timezone
  do_not_countme             = local.do_not_countme
  rollout_wariness           = local.rollout_wariness
  periodic_updates           = local.periodic_updates
  keymap                     = local.keymap
  sync_time_with_host        = local.sync_time_with_host
  etc_hosts                  = local.etc_hosts
  additional_rpms            = local.additional_rpms
  vcpu                       = local.vcpu
  memory                     = local.memory
  root_volume_size           = local.root_volume_size
  log_volume_size            = local.log_volume_size
  data_volume_size           = local.data_volume_size
  backup_volume_size         = local.backup_volume_size

  root_base_volume_name = libvirt_volume.fcos_image.name
  network_id            = libvirt_network.libvirt_fcos_base.id
}
