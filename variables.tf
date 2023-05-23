# butane custom
variable "qemu_agent" {
  type        = bool
  description = "Install qemu guest agent"
  default     = true
  nullable    = false
}

variable "butane_snippets_additional" {
  type        = list(string)
  default     = []
  description = "Additional butane snippets"
  nullable    = false
}

variable "systemd_pager" {
  type        = string
  description = "Systemd pager"
  default     = "cat"
  nullable    = false
}

variable "sysctl" {
  description = "Additional kernel tuning in sysctl.d"
  type        = map(string)
  default = {
    "vm.swappiness" = "0"
  }
}

# butane common
variable "ssh_authorized_key" {
  type        = string
  description = "Authorized ssh key for core user"
}

variable "nameservers" {
  type        = list(string)
  description = "List of nameservers for VMs"
  default     = ["8.8.8.8"]
  nullable    = false
}

variable "timezone" {
  type        = string
  description = "Timezone for VMs as listed by `timedatectl list-timezones`"
  default     = null
}

variable "do_not_countme" {
  type        = bool
  description = "Disable Fedora CoreOS infrastructure count me feature"
  default     = true
}

variable "rollout_wariness" {
  type        = string
  description = "Wariness to update, 1.0 (very cautious) to 0.0 (very eager)"
  default     = null
}

variable "periodic_updates" {
  type = object(
    {
      time_zone = optional(string, "")
      windows = list(
        object(
          {
            days           = list(string)
            start_time     = string
            length_minutes = string
          }
        )
      )
    }
  )
  description = <<-TEMPLATE
    Only reboot for updates during certain timeframes
    {
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
  TEMPLATE
  default     = null
}

variable "interface_name" {
  type        = string
  description = "Network interface name"
  default     = null
}

variable "keymap" {
  type        = string
  description = "Keymap"
  default     = null
}

variable "sync_time_with_host" {
  type        = bool
  description = "Sync guest time with the kvm host"
  default     = null
}

variable "etc_hosts" {
  type = list(
    object(
      {
        ip       = string
        hostname = string
        fqdn     = string
      }
    )
  )
  description = "/etc/host list"
  default     = null
}

variable "etc_hosts_extra" {
  type        = string
  description = "/etc/host extra block"
  default     = null
}

variable "additional_rpms" {
  type = object(
    {
      cmd_pre  = optional(list(string), [])
      list     = optional(list(string), [])
      cmd_post = optional(list(string), [])
    }
  )
  description = "Additional rpms to install during boot using rpm-ostree, along with any pre or post command"
  default = {
    cmd_pre  = []
    list     = []
    cmd_post = []
  }
  nullable = false
}

# libvirt node
variable "fqdn" {
  type        = string
  description = "Node FQDN"
}

variable "cidr_ip_address" {
  type        = string
  description = "CIDR IP Address. Ex: 192.168.1.101/24"
  validation {
    condition     = can(cidrhost(var.cidr_ip_address, 1))
    error_message = "Check cidr_ip_address format"
  }
  default = null
}

variable "mac" {
  type        = string
  description = "Mac address"
  default     = null
}

variable "cpu_mode" {
  type        = string
  description = "Libvirt default cpu mode for VMs"
  default     = "host-passthrough"
  nullable    = false
}

variable "vcpu" {
  type        = number
  description = "Node default vcpu count"
  default     = 1
  nullable    = false
}

variable "memory" {
  type        = number
  description = "Node default memory in MiB"
  default     = 512
  nullable    = false
}

variable "libosinfo_id" {
  type        = string
  description = "Id for libosinfo/os type. See https://gitlab.com/libosinfo/osinfo-db/-/tree/main"
  default     = "http://fedoraproject.org/coreos/stable"
  nullable    = false
}

variable "xslt_snippet" {
  type        = string
  description = "Snippet specifying XSLT to transform the generated XML definition before creating the domain."
  default     = ""
  nullable    = false
}

variable "arch" {
  type        = string
  description = "The architecture for the VM (probably x86_64 or i686), you normally won't need to set this unless you are building a special VM"
  default     = null
}

variable "cmdline" {
  type        = list(map(string))
  description = "Arguments to the kernel"
  default     = []
}

variable "emulator" {
  type        = string
  description = "The path of the emulator to use"
  default     = null
}

variable "machine" {
  type        = string
  description = "The machine type, you normally won't need to set this unless you are running on a platform that defaults to the wrong machine type for your template"
  default     = null
}

variable "firmware" {
  type        = string
  description = "The UEFI rom images for exercising UEFI secure boot in a qemu environment."
  default     = null
}

variable "nvram" {
  type = object(
    {
      file     = string
      template = optional(string)

    }
  )
  description = "This block allows specifying the following attributes related to the nvram"
  default     = null
}

variable "root_volume_format" {
  type        = string
  description = "Node default root volume mount format"
  default     = "qcow2"
  nullable    = false
}

variable "root_volume_pool" {
  type        = string
  description = "Node default root volume pool"
  default     = null
}

variable "root_volume_size" {
  type        = number
  description = "Node default root volume size in bytes"
  default     = 1024 * 1024 * 1024 * 20 # in bytes, 20 Gi
  nullable    = false
}

variable "root_base_volume_name" {
  type        = string
  description = "Node default base root volume name"
  nullable    = false
}

variable "root_base_volume_pool" {
  type        = string
  description = "Node default base root volume pool"
  default     = null
}

variable "log_volume" {
  type        = bool
  description = "Create log volume"
  default     = true
  nullable    = false
}

variable "log_volume_format" {
  type        = string
  description = "Node default log volume mount format"
  default     = "qcow2"
  nullable    = false
}

variable "log_volume_path" {
  type        = string
  description = "Node default log volume mount path "
  default     = "/var/log"
  nullable    = false
}

variable "log_volume_pool" {
  type        = string
  description = "Node default log volume pool"
  default     = null
}

variable "log_volume_size" {
  type        = number
  description = "Node default log volume size in bytes"
  default     = 1024 * 1024 * 1024 * 5 # in bytes, 5 Gi
  nullable    = false
}

variable "data_volume" {
  type        = bool
  description = "Create data volume"
  default     = true
  nullable    = false
}

variable "data_volume_format" {
  type        = string
  description = "Node default data volume mount format"
  default     = "qcow2"
  nullable    = false
}

variable "data_volume_path" {
  type        = string
  description = "Node default data volume mount path "
  default     = "/var/mnt/data"
  nullable    = false
}

variable "data_volume_pool" {
  type        = string
  description = "Node default data volume pool"
  default     = null
}

variable "data_volume_size" {
  type        = number
  description = "Node default data volume size in bytes"
  default     = 1024 * 1024 * 1024 * 20 # in bytes, 20 Gi
  nullable    = false
}

variable "backup_volume" {
  type        = bool
  description = "Create backup volume"
  default     = true
  nullable    = false
}

variable "backup_volume_format" {
  type        = string
  description = "Node default backup volume mount format"
  default     = "qcow2"
  nullable    = false
}

variable "backup_volume_path" {
  type        = string
  description = "Node default backup volume mount path "
  default     = "/var/mnt/backup"
  nullable    = false
}

variable "backup_volume_pool" {
  type        = string
  description = "Node default backup volume pool"
  default     = null
}

variable "backup_volume_size" {
  type        = number
  description = "Node default backup volume size in bytes"
  default     = 1024 * 1024 * 1024 * 20 # in bytes, 20 Gi
  nullable    = false
}

variable "ignition_pool" {
  type        = string
  description = "Default ignition files pool"
  default     = null
}

variable "wait_for_lease" {
  type        = bool
  description = "Wait for network lease"
  default     = false
  nullable    = false
}

variable "autostart" {
  type        = bool
  description = "Autostart with libvirt host"
  default     = true
  nullable    = false
}

variable "network_bridge" {
  type        = string
  description = "Libvirt default network bridge name for VMs"
  default     = null
}

variable "network_id" {
  type        = string
  description = "Libvirt default network id for VMs"
  default     = null
}

variable "network_name" {
  type        = string
  description = "Libvirt default network name for VMs"
  default     = null
}
