# Resource block creating firewall addresses per vdom
resource "fortios_firewall_address" "netbox_objects" {
  for_each = local.address_objects

  name      = each.value.name
  subnet    = each.value.subnet
  #comment   = each.value.comment
  type      = "ipmask"
  color     = each.value.color

  # Use ternary to assign vdomparam or empty string if null
  vdomparam = each.value.vdom != null ? each.value.vdom : ""
}