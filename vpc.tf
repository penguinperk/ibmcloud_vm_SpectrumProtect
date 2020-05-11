variable "ssh_key" {
}

locals {
  BASENAME = "scott"
  ZONE     = "us-south-1"
  IAM_PROFILE = "cc1-2x4"
}

resource "ibm_is_vpc" "vpc" {
  name = "${local.BASENAME}-vpc"
}

#For VPC
#resource "ibm_is_public_gateway" "testaccgateway" {
#    name = "gateway"
#    vpc = ibm_is_vpc.vpc.id
#    zone = "local.ZONE"
##
#    //User can configure timeouts
#    timeouts {
#        create = "90m"
#    }
#}

resource "ibm_is_security_group" "sg1" {
  name = "${local.BASENAME}-sg1"
  vpc  = ibm_is_vpc.vpc.id
}

# allow all incoming network traffic on port 22
resource "ibm_is_security_group_rule" "ingress_ssh_all" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}

# allow all out network traffic
resource "ibm_is_security_group_rule" "engress" {
  group     = ibm_is_security_group.sg1.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}


resource "ibm_is_subnet" "subnet1" {
  name                     = "${local.BASENAME}-subnet1"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = local.ZONE
  total_ipv4_address_count = 256
}

data "ibm_is_image" "RHEL76" {
  name = "ibm-redhat-7-6-minimal-amd64-1"
}

data "ibm_is_ssh_key" "ssh_key_id" {
  name = var.ssh_key
}

resource "ibm_is_instance" "vsi1" {
  name    = "${local.BASENAME}-vsi1"
  vpc     = ibm_is_vpc.vpc.id
  zone    = local.ZONE
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  image   = data.ibm_is_image.RHEL76.id
  profile = local.IAM_PROFILE

  primary_network_interface {
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }
}

resource "ibm_is_floating_ip" "fip1" {
  name   = "${local.BASENAME}-fip1"
  target = ibm_is_instance.vsi1.primary_network_interface[0].id
}

output "sshcommand" {
    value = "ssh root@ibm_is_floating_ip.fip1.address"
}

