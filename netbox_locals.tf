data "http" "netbox_prefixes" {
  url = "http://10.20.20.207:8000/api/ipam/prefixes/"
  request_headers = {
    Authorization = "Token 83947700300503988007603229d9ca12935d0e02"
    Accept        = "application/json"
  }
}

# locals block mapping each prefix to a key of "<vdom>_<name>"
locals {
  address_objects = {
    for prefix in jsondecode(data.http.netbox_prefixes.response_body).results :
    "${prefix.vrf.name}_${replace(prefix.description, " ", "_")}" => {
      name    = "${prefix.vrf.name}_${replace(prefix.description, " ", "_")}"
      subnet  = prefix.prefix
      comment = prefix.description
      vdom    = coalesce(prefix.vrf.name, "root")
      color   = lookup(prefix.custom_fields, "ipam_color", null)
    }
  }
}
