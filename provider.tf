# Configure the FortiOS Provider for FortiGate
terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
    }
  }
}

provider "fortios" {
  hostname = "###YOUR-FORTIGATE-IP_HOSTNAME_HERE"
  token    = "###YOUR-FORTIGATE-ADMIN_API_KEY-HERE"
  insecure = "true"
}
