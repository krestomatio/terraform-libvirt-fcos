locals {
  hostname        = var.fqdn
  additional_rpms = var.qemu_agent ? { list = concat(var.additional_rpms.list, ["qemu-guest-agent"]), cmd_post = concat(var.additional_rpms.cmd_post, ["/usr/bin/systemctl enable --now qemu-guest-agent.service"]), cmd_pre = var.additional_rpms.cmd_pre } : var.additional_rpms
  additional_disks = flatten(
    [
      var.log_volume ? [{ volume_id = libvirt_volume.log[0].id }] : [],
      var.data_volume ? [{ volume_id = libvirt_volume.data[0].id }] : [],
      var.backup_volume ? [{ volume_id = libvirt_volume.backup[0].id }] : [],
      var.additional_disks
    ]
  )
  default_storage_disks = flatten(
    [
      var.log_volume ? [{ label = "log", path = var.log_volume_path }] : [],
      var.data_volume ? [{ label = "data", path = var.data_volume_path }] : [],
      var.backup_volume ? [{ label = "backup", path = var.backup_volume_path }] : []
    ]
  )
  default_disk_devices = [
    "/dev/vdb",
    "/dev/vdc",
    "/dev/vdd"
  ]
  default_storage = {
    disks = [for index, disk in local.default_storage_disks :
      {
        device     = local.default_disk_devices[index]
        wipe_table = true
        partitions = [
          {
            resize    = true
            label     = disk.label
            number    = 1
            size_mib  = 0
            start_mib = 0
          }
        ]
      }
    ]
    filesystems = [for index, disk in local.default_storage_disks :
      {
        device          = "/dev/disk/by-partlabel/${disk.label}"
        path            = disk.path
        format          = "xfs"
        label           = disk.label
        with_mount_unit = true
      }
    ]
  }
  butane_k3s_snippets = compact(
    [
      module.butane_common_snippets.hostname,
      module.butane_common_snippets.keymap,
      module.butane_common_snippets.timezone,
      module.butane_common_snippets.periodic_updates,
      module.butane_common_snippets.rollout_wariness,
      module.butane_common_snippets.core_authorized_key,
      module.butane_common_snippets.static_interface,
      module.butane_common_snippets.etc_hosts,
      module.butane_common_snippets.disks,
      module.butane_common_snippets.filesystems,
      module.butane_common_snippets.additional_rpms,
      module.butane_common_snippets.sync_time_with_host,
      module.butane_common_snippets.systemd_pager,
      module.butane_common_snippets.sysctl,
      module.butane_common_snippets.do_not_countme
    ]
  )
  butane_snippets = concat(local.butane_k3s_snippets, var.butane_snippets_additional)
  xslt            = <<TEMPLATE
<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output omit-xml-declaration="yes" indent="yes"/>
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/domain">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
      <xsl:element name="metadata">
        <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
          <xsl:element name="libosinfo:os">
            <xsl:attribute name="id">${var.libosinfo_id}</xsl:attribute>
          </xsl:element>
        </libosinfo:libosinfo>
      </xsl:element>
    </xsl:copy>
  </xsl:template>

  %{~if var.xslt_snippet != ""~}
  ${var.xslt_snippet}
  %{~endif~}
</xsl:stylesheet>
TEMPLATE
}
