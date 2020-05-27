data "ibm_is_image" "RHEL76" {
  name = "ibm-redhat-7-6-minimal-amd64-1"
}

resource "ibm_is_instance" "vsi1" {
  name    = "${var.BASENAME}-${var.hostapp}"
  vpc     = ibm_is_vpc.vpc.id
  zone    = var.ZONE
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  image   = data.ibm_is_image.RHEL76.id
  profile = var.IAM_PROFILE

  primary_network_interface {
    name            = "primarynetwork"
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }

  boot_volume {
    name = "${var.hostapp}-boot"
  }
  volumes = [ibm_is_volume.container.id, ibm_is_volume.db.id]
}