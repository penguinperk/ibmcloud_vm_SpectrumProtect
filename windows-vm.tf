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

  tags = [ 
  "customer = dot foods",
  "environment = trial",
  "project = spectrum protect",
  "automated = terraform",
  "owner = scott perkins"
  ]

  volumes = [ibm_is_volume.windows-db1.id, 
             ibm_is_volume.windows-db2.id, 
             ibm_is_volume.windows-config.id,
             ibm_is_volume.windows-active.id,
             ibm_is_volume.windows-archive.id,
             ibm_is_volume.windows-dbbackup1.id,
             ibm_is_volume.windows-container1.id,
             ibm_is_volume.windows-container2.id,
             ibm_is_volume.windows-container3.id,
             ibm_is_volume.windows-container4.id,
             ibm_is_volume.windows-container5.id
             ]
#  volumes = [ibm_is_volume.container.id, ibm_is_volume.db.id]
}
resource "ibm_is_volume" "windows-db1" {
  name     = "${var.BASENAME}-db1"
  profile  = "5iops-tier"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-db2" {
  name     = "${var.BASENAME}-db2"
  profile  = "5iops-tier"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-config" {
  name     = "${var.BASENAME}-win-config"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 50
}
resource "ibm_is_volume" "windows-active" {
  name     = "${var.BASENAME}-win-activelog"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 300
}

resource "ibm_is_volume" "windows-archive" {
  name     = "${var.BASENAME}-win-arch-log"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-dbbackup1" {
  name     = "${var.BASENAME}-win-dbbackup1"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 2000 
}
resource "ibm_is_volume" "windows-container1" {
  name     = "${var.BASENAME}-win-container1"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-container2" {
  name     = "${var.BASENAME}-win-container2"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-container3" {
  name     = "${var.BASENAME}-win-container3"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-container4" {
  name     = "${var.BASENAME}-win-container4"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_volume" "windows-container5" {
  name     = "${var.BASENAME}-win-container5"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 1000
}
resource "ibm_is_floating_ip" "fipwin" {
  name   = "${var.BASENAME}-fipwin"
  target = ibm_is_instance.WIN2016.primary_network_interface[0].id
}
output "winexternalip" {
  value       = ibm_is_floating_ip.fipwin.address
  description = "External Floating IP"
}