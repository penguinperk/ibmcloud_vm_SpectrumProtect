
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
  public_gateway           = ibm_is_public_gateway.testacc_gateway.id
  total_ipv4_address_count = 256
  #ipv4_cidr_block = var.ipv4_subnet
}

resource "ibm_is_subnet" "my-subnet1" {
  name            = "${var.BASENAME}-mysubnet1"
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.ZONE
  public_gateway  = ibm_is_public_gateway.testacc_gateway.id
  ipv4_cidr_block = "10.80.0.0/24"
}

resource "ibm_is_vpc_address_prefix" "myvpc_address_prefix" {
  name = "mysubnetprefix"
  zone = var.ZONE
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.80.0.0/24"
}

resource "ibm_is_public_gateway" "testacc_gateway" {
  name = "public-gateway"
  vpc  = ibm_is_vpc.vpc.id
  zone = "us-south-1"
}

#resource "ibm_is_ssh_key" "ssh_key_id" {
#  name       = "gen2"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjTp/4LYLHYbvj2/aTh3p+6S0pjvHUbZLuKBFL5BPVr9Gsux1E6xTLjsZ8Y9/QO4Vst02myr7NU+qZxOcFs84qU0bXXHRlvLDzZLxEyV+GUVwfm0qMhl9mUIMPfJKkGKZP8cHEGibOLwhpOFjaunRBKbLjO0NKSNo07aUhMqxpSQ/YIeQGJvzsOXHDrHoNMFVe8jBKMw8HVWX0OwfysJ5IgF6n5aOxL1b6Am1wp6gc4+0sPXFA6+p67CSWjW/UY7KsSWfVhtD6X9lMDnFNRmgjRJqdgMdo/H3N4qefRYkfbvuy6QLHNof2Ap+ctvpAVabLguCOI3b6Rj65zu8prroz perkins@HW09361.local"
#
#  tags = [ 
#  "customer = dot foods",
#  "environment = trial",
#  "project = spectrum protect",
#  "automated = terraform",
#  "owner = scott perkins"
#  ]
#}
data "ibm_is_ssh_key" "ssh_key_id" {
  name = var.ssh_key
}
