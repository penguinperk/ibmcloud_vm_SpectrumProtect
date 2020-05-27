data "ibm_is_image" "WIN2016" {
  name = "ibm-windows-server-2016-full-standard-amd64-3"
}
resource "ibm_is_instance" "WIN2016" {
  name    = "${var.BASENAME}-windows2016"
  vpc     = ibm_is_vpc.vpc.id
  zone    = var.ZONE
  keys    = [data.ibm_is_ssh_key.ssh_key_id.id]
  image   = data.ibm_is_image.WIN2016.id
  profile = var.IAM_PROFILE

  primary_network_interface {
    name            = "primarynetwork"
    subnet          = ibm_is_subnet.subnet1.id
    security_groups = [ibm_is_security_group.sg1.id]
  }

  boot_volume {
    name = "windows2016-boot"
  }

  volumes = [ibm_is_volume.windows-container.id, ibm_is_volume.windows-db.id]
#  volumes = [ibm_is_volume.container.id, ibm_is_volume.db.id]
}
resource "ibm_is_volume" "windows-db" {
  name     = "${var.BASENAME}-win-db"
  profile  = "5iops-tier"
  zone     = "us-south-1"
  capacity = 400
}
resource "ibm_is_volume" "windows-container" {
  name     = "${var.BASENAME}-win-container"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 800
}
