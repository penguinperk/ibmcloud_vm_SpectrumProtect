
locals {
  #  BASENAME    = "scott"
  #  ZONE        = "us-south-1"
  # IAM_PROFILE = "cx2-2x4"
}

resource "ibm_is_vpc" "vpc" {
  name = "${var.BASENAME}-vpc"
}

resource "ibm_is_security_group" "sg1" {
  name = "${var.BASENAME}-sg1"
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
# allow all incoming network traffic on port 22
resource "ibm_is_security_group_rule" "ingress_rdp_all" {
  group     = ibm_is_security_group.sg1.id
  direction = "inbound"
  remote    = "98.222.12.23"

  tcp {
    port_min = 3389
    port_max = 3389
  }
}

# allow all out network traffic
resource "ibm_is_security_group_rule" "engress" {
  group     = ibm_is_security_group.sg1.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}


resource "ibm_is_subnet" "subnet1" {
  name                     = "${var.BASENAME}-subnet1"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.ZONE
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.testacc_gateway.id
}

data "ibm_is_ssh_key" "ssh_key_id" {
  name = var.ssh_key
}

resource "ibm_is_floating_ip" "fip1" {
  name   = "${var.BASENAME}-fip1"
  target = ibm_is_instance.vsi1.primary_network_interface[0].id
}

resource "ibm_is_public_gateway" "testacc_gateway" {
  name = "testgateway"
  vpc  = ibm_is_vpc.vpc.id
  zone = "us-south-1"
}
