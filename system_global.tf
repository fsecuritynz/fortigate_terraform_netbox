resource "fortios_system_global" "system_hostname" {
  alias          = "###YOUR-FORTIGATE-HOSTNAME_HERE"
  hostname       = "###YOUR-FORTIGATE-HOSTNAME_HERE"
  admintimeout   = 65
  admin_sport    = 443
  admin_ssh_port = 22
  admin_scp      = "enable"
  gui_theme            = "eclipse"
}
