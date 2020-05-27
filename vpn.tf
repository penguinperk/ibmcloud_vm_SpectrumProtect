resource "ibm_is_ipsec_policy" "ipsecpolicy" {
  name                     = "ipsec-policy-terraform"
  authentication_algorithm = "sha256"
  encryption_algorithm     = "aes256"
  pfs                      = "disabled"
}

resource "ibm_is_vpn_gateway" "vpngateway" {
  name   = "vpn-gateway-terraform"
  subnet = ibm_is_subnet.subnet1.id
}

resource "ibm_is_vpn_gateway_connection" "VPNGatewayConnection" {
  name           = "test2"
  vpn_gateway    = ibm_is_vpn_gateway.vpngateway.id
  peer_address   = "98.222.12.23"
  preshared_key  = "123456"
  local_cidrs    = [ibm_is_subnet.subnet1.ipv4_cidr_block]
  peer_cidrs     = ["192.168.11.0/24"]
  admin_state_up = "true"
}
output "vpnpublicip" {
  value       = ibm_is_vpn_gateway.vpngateway.public_ip_address
  description = "VPN's External IP"
}