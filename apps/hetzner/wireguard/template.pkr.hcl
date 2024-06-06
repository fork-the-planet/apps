variable "app_name" {
  type    = string
  default = "wireguard"
}

variable "app_version" {
  type    = string
  default = "latest"
}

variable "hcloud_image" {
  type    = string
  default = "ubuntu-24.04"
}

variable "apt_packages" {
  type    = string
  default = "wireguard"
}

variable "wireguard_ui_version" {
  type    = string
  default = "0.6.2"
}

variable "caddy_version" {
  type    = string
  default = "2.8.4"
}

build {
  sources = ["source.hcloud.autogenerated_1"]

  provisioner "shell" {
    inline = ["cloud-init status --wait --long"]
    valid_exit_codes = [0, 2]
  }

  provisioner "file" {
    destination = "/etc/"
    source      = "apps/hetzner/wireguard/files/etc/"
  }

  provisioner "file" {
    destination = "/opt/"
    source      = "apps/hetzner/wireguard/files/opt/"
  }

  provisioner "file" {
    destination = "/var/"
    source      = "apps/hetzner/wireguard/files/var/"
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh"]
  }

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    inline           = ["apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install ${var.apt_packages}"]
  }

  provisioner "shell" {
    environment_vars = ["application_name=${var.app_name}", "application_version=${var.app_version}", "wireguard_ui_version=${var.wireguard_ui_version}", "caddy_version=${var.caddy_version}", "DEBIAN_FRONTEND=noninteractive", "LC_ALL=C", "LANG=en_US.UTF-8", "LC_CTYPE=en_US.UTF-8"]
    scripts          = ["apps/shared/scripts/apt-upgrade.sh", "apps/hetzner/wireguard/scripts/install.sh", "apps/shared/scripts/cleanup.sh"]
  }
}
