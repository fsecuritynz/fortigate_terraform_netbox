data "http" "netbox_interfaces" {
  url = "http://###YOUT-NETBOX-IP_HOSTNAME-HERE:8000/api/ipam/ip-addresses/"
  request_headers = {
    Authorization = "Token ###YOUR-TOKEN-HERE"
    Accept        = "application/json"
  }
}

locals {
  netbox_data = jsondecode(data.http.netbox_interfaces.response_body)

  interfaces = [
    for item in local.netbox_data.results : {
      name        = item.description != "" ? item.description : "${item.assigned_object.device.name}_${item.assigned_object.name}"
      ip_address  = item.address
      vlan_id     = lookup(item.custom_fields, "ip_vlanid", "") != "" ? tonumber(lookup(item.custom_fields, "ip_vlanid", "0")) : 0
      zone        = lookup(item.custom_fields, "security_zone", "default")
      vdom        = item.vrf != null && item.vrf.name != "" ? item.vrf.name : "root"
      interface   = item.assigned_object.name
      device_name = item.assigned_object.device.name
      // sanitized name to remove spaces or problematic chars for FortiGate zone interface assignment:
      sanitized_name = replace(item.description != "" ? item.description : "${item.assigned_object.device.name}_${item.assigned_object.name}", " ", "_")
    }
  ]

  interfaces_by_name = {
    for i in local.interfaces : i.name => i
  }

  zones = {
    for zone_key in distinct([
      for i in local.interfaces : "${i.vdom}_${i.zone}"
    ]) : zone_key => {
      zone            = split("_", zone_key)[1]
      vdom            = split("_", zone_key)[0]
      interface_names = [
        for i in local.interfaces : i.sanitized_name
        if "${i.vdom}_${i.zone}" == zone_key
      ]
    }
  }
}

resource "fortios_system_interface" "netbox_interfaces" {
  for_each = local.interfaces_by_name

  name      = each.value.name
  vdom      = each.value.vdom
  ip        = each.value.ip_address
  type      = "vlan"
  interface = each.value.interface
  vlanid    = each.value.vlan_id != 0 ? each.value.vlan_id : null
  role      = "lan"
}

resource "fortios_system_zone" "zones" {
  for_each = local.zones

  name      = each.value.zone
  vdomparam = each.value.vdom

  dynamic "interface" {
    for_each = each.value.interface_names
    content {
      interface_name = interface.value
    }
  }

  depends_on = [
    # Ensure all interfaces are created before zones
    fortios_system_interface.netbox_interfaces
  ]
}
