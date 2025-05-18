# fortigate_terraform_netbox
Building Interfaces and Security Zones for Fortigate Firewall using Netbox Data and Terraform



# Initial Variables Required

## provider.tf
  hostname = "###YOUR-FORTIGATE-IP_HOSTNAME_HERE"

  token    = "###YOUR-FORTIGATE-ADMIN_API_KEY-HERE"

## system_global.tf
  alias          = "###YOUR-FORTIGATE-HOSTNAME_HERE"
  
  hostname       = "###YOUR-FORTIGATE-HOSTNAME_HERE"



## netbox_interface.tf
  url = "http://###YOUT-NETBOX-IP_HOSTNAME-HERE:8000/api/ipam/ip-addresses/"
  
  Authorization = "Token ###YOUR-TOKEN-HERE"



# Netbox Setup: Custom Parameters (Object Type: IP Address)
- ip_type
- ip_vlanid 
- security_zone


**consult json for more info**
