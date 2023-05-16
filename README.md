Terraform module to quickly generate a virtual machine using [Fedora CoreOS](https://docs.fedoraproject.org/en-US/fedora-coreos/) and [Libvirt](https://libvirt.org/).

## Dependencies
The following are the dependencies to create k3s cluster with this module:
* [libvirt](https://libvirt.org/)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_ct"></a> [ct](#requirement\_ct) | 0.11.0 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | ~> 0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ct"></a> [ct](#provider\_ct) | 0.11.0 |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | ~> 0.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_butane_common_snippets"></a> [butane\_common\_snippets](#module\_butane\_common\_snippets) | krestomatio/butane-snippets/ct//modules/common | 0.0.13 |

## Resources

| Name | Type |
|------|------|
| [libvirt_domain.node](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain) | resource |
| [libvirt_ignition.node](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/ignition) | resource |
| [libvirt_volume.backup](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.data](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.log](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.root](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [ct_config.node](https://registry.terraform.io/providers/poseidon/ct/0.11.0/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_rpms"></a> [additional\_rpms](#input\_additional\_rpms) | Additional rpms to install during boot using rpm-ostree, along with any pre or post command | <pre>object(<br>    {<br>      cmd_pre  = optional(list(string), [])<br>      list     = optional(list(string), [])<br>      cmd_post = optional(list(string), [])<br>    }<br>  )</pre> | <pre>{<br>  "cmd_post": [],<br>  "cmd_pre": [],<br>  "list": []<br>}</pre> | no |
| <a name="input_arch"></a> [arch](#input\_arch) | The architecture for the VM (probably x86\_64 or i686), you normally won't need to set this unless you are building a special VM | `string` | `null` | no |
| <a name="input_autostart"></a> [autostart](#input\_autostart) | Autostart with libvirt host | `bool` | `true` | no |
| <a name="input_backup_volume"></a> [backup\_volume](#input\_backup\_volume) | Create backup volume | `bool` | `true` | no |
| <a name="input_backup_volume_format"></a> [backup\_volume\_format](#input\_backup\_volume\_format) | Node default backup volume mount format | `string` | `"qcow2"` | no |
| <a name="input_backup_volume_path"></a> [backup\_volume\_path](#input\_backup\_volume\_path) | Node default backup volume mount path | `string` | `"/var/mnt/backup"` | no |
| <a name="input_backup_volume_pool"></a> [backup\_volume\_pool](#input\_backup\_volume\_pool) | Node default backup volume pool | `string` | `null` | no |
| <a name="input_backup_volume_size"></a> [backup\_volume\_size](#input\_backup\_volume\_size) | Node default backup volume size in bytes | `number` | `21474836480` | no |
| <a name="input_butane_snippets_additional"></a> [butane\_snippets\_additional](#input\_butane\_snippets\_additional) | Additional butane snippets | `list(string)` | `[]` | no |
| <a name="input_cidr_ip_address"></a> [cidr\_ip\_address](#input\_cidr\_ip\_address) | CIDR IP Address. Ex: 192.168.1.101/24 | `string` | `null` | no |
| <a name="input_cmdline"></a> [cmdline](#input\_cmdline) | Arguments to the kernel | `list(map(string))` | `[]` | no |
| <a name="input_cpu_mode"></a> [cpu\_mode](#input\_cpu\_mode) | Libvirt default cpu mode for VMs | `string` | `"host-passthrough"` | no |
| <a name="input_data_volume"></a> [data\_volume](#input\_data\_volume) | Create data volume | `bool` | `true` | no |
| <a name="input_data_volume_format"></a> [data\_volume\_format](#input\_data\_volume\_format) | Node default data volume mount format | `string` | `"qcow2"` | no |
| <a name="input_data_volume_path"></a> [data\_volume\_path](#input\_data\_volume\_path) | Node default data volume mount path | `string` | `"/var/mnt/data"` | no |
| <a name="input_data_volume_pool"></a> [data\_volume\_pool](#input\_data\_volume\_pool) | Node default data volume pool | `string` | `null` | no |
| <a name="input_data_volume_size"></a> [data\_volume\_size](#input\_data\_volume\_size) | Node default data volume size in bytes | `number` | `21474836480` | no |
| <a name="input_do_not_countme"></a> [do\_not\_countme](#input\_do\_not\_countme) | Disable Fedora CoreOS infrastructure count me feature | `bool` | `true` | no |
| <a name="input_emulator"></a> [emulator](#input\_emulator) | The path of the emulator to use | `string` | `null` | no |
| <a name="input_etc_hosts"></a> [etc\_hosts](#input\_etc\_hosts) | /etc/host list | <pre>list(<br>    object(<br>      {<br>        ip       = string<br>        hostname = string<br>        fqdn     = string<br>      }<br>    )<br>  )</pre> | `null` | no |
| <a name="input_etc_hosts_extra"></a> [etc\_hosts\_extra](#input\_etc\_hosts\_extra) | /etc/host extra block | `string` | `null` | no |
| <a name="input_firmware"></a> [firmware](#input\_firmware) | The UEFI rom images for exercising UEFI secure boot in a qemu environment. | `string` | `null` | no |
| <a name="input_fqdn"></a> [fqdn](#input\_fqdn) | Node FQDN | `string` | n/a | yes |
| <a name="input_ignition_pool"></a> [ignition\_pool](#input\_ignition\_pool) | Default ignition files pool | `string` | `null` | no |
| <a name="input_interface_name"></a> [interface\_name](#input\_interface\_name) | Network interface name | `string` | `null` | no |
| <a name="input_keymap"></a> [keymap](#input\_keymap) | Keymap | `string` | `null` | no |
| <a name="input_libosinfo_id"></a> [libosinfo\_id](#input\_libosinfo\_id) | Id for libosinfo/os type. See https://gitlab.com/libosinfo/osinfo-db/-/tree/main | `string` | `"http://fedoraproject.org/coreos/stable"` | no |
| <a name="input_log_volume"></a> [log\_volume](#input\_log\_volume) | Create log volume | `bool` | `true` | no |
| <a name="input_log_volume_format"></a> [log\_volume\_format](#input\_log\_volume\_format) | Node default log volume mount format | `string` | `"qcow2"` | no |
| <a name="input_log_volume_path"></a> [log\_volume\_path](#input\_log\_volume\_path) | Node default log volume mount path | `string` | `"/var/log"` | no |
| <a name="input_log_volume_pool"></a> [log\_volume\_pool](#input\_log\_volume\_pool) | Node default log volume pool | `string` | `null` | no |
| <a name="input_log_volume_size"></a> [log\_volume\_size](#input\_log\_volume\_size) | Node default log volume size in bytes | `number` | `5368709120` | no |
| <a name="input_mac"></a> [mac](#input\_mac) | Mac address | `string` | `null` | no |
| <a name="input_machine"></a> [machine](#input\_machine) | The machine type, you normally won't need to set this unless you are running on a platform that defaults to the wrong machine type for your template | `string` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Node default memory in MiB | `number` | `512` | no |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | List of nameservers for VMs | `list(string)` | <pre>[<br>  "8.8.8.8"<br>]</pre> | no |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | Libvirt default network bridge name for VMs | `string` | `null` | no |
| <a name="input_network_id"></a> [network\_id](#input\_network\_id) | Libvirt default network id for VMs | `string` | `null` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Libvirt default network name for VMs | `string` | `null` | no |
| <a name="input_nvram"></a> [nvram](#input\_nvram) | This block allows specifying the following attributes related to the nvram | <pre>object(<br>    {<br>      file     = string<br>      template = optional(string)<br><br>    }<br>  )</pre> | `null` | no |
| <a name="input_periodic_updates"></a> [periodic\_updates](#input\_periodic\_updates) | Only reboot for updates during certain timeframes<br>{<br>  time\_zone = "localtime"<br>  windows = [<br>    {<br>      days           = ["Sat"],<br>      start\_time     = "23:30",<br>      length\_minutes = "60"<br>    },<br>    {<br>      days           = ["Sun"],<br>      start\_time     = "00:30",<br>      length\_minutes = "60"<br>    }<br>  ]<br>} | <pre>object(<br>    {<br>      time_zone = optional(string, "")<br>      windows = list(<br>        object(<br>          {<br>            days           = list(string)<br>            start_time     = string<br>            length_minutes = string<br>          }<br>        )<br>      )<br>    }<br>  )</pre> | `null` | no |
| <a name="input_qemu_agent"></a> [qemu\_agent](#input\_qemu\_agent) | Install qemu guest agent | `bool` | `true` | no |
| <a name="input_rollout_wariness"></a> [rollout\_wariness](#input\_rollout\_wariness) | Wariness to update, 1.0 (very cautious) to 0.0 (very eager) | `string` | `null` | no |
| <a name="input_root_base_volume_name"></a> [root\_base\_volume\_name](#input\_root\_base\_volume\_name) | Node default base root volume name | `string` | n/a | yes |
| <a name="input_root_base_volume_pool"></a> [root\_base\_volume\_pool](#input\_root\_base\_volume\_pool) | Node default base root volume pool | `string` | `null` | no |
| <a name="input_root_volume_format"></a> [root\_volume\_format](#input\_root\_volume\_format) | Node default root volume mount format | `string` | `"qcow2"` | no |
| <a name="input_root_volume_pool"></a> [root\_volume\_pool](#input\_root\_volume\_pool) | Node default root volume pool | `string` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Node default root volume size in bytes | `number` | `21474836480` | no |
| <a name="input_ssh_authorized_key"></a> [ssh\_authorized\_key](#input\_ssh\_authorized\_key) | Authorized ssh key for core user | `string` | n/a | yes |
| <a name="input_sync_time_with_host"></a> [sync\_time\_with\_host](#input\_sync\_time\_with\_host) | Sync guest time with the kvm host | `bool` | `null` | no |
| <a name="input_systemd_pager"></a> [systemd\_pager](#input\_systemd\_pager) | Systemd pager | `string` | `"cat"` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone for VMs as listed by `timedatectl list-timezones` | `string` | `null` | no |
| <a name="input_vcpu"></a> [vcpu](#input\_vcpu) | Node default vcpu count | `number` | `1` | no |
| <a name="input_wait_for_lease"></a> [wait\_for\_lease](#input\_wait\_for\_lease) | Wait for network lease | `bool` | `false` | no |
| <a name="input_xslt_snippet"></a> [xslt\_snippet](#input\_xslt\_snippet) | Snippet specifying XSLT to transform the generated XML definition before creating the domain. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->