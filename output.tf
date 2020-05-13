output "sshcommand" {
  value = ibm_is_floating_ip.fip1.address
  description = "External Floating IP"
}
output "vpnpublicip" {
  value  = ibm_is_vpn_gateway.vpngatway.public_ip_address
  description = "VPN's External IP:wq"
}
