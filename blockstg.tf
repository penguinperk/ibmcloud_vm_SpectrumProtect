resource "ibm_is_volume" "container" {
  name     = "${var.BASENAME}-container"
  profile  = "general-purpose"
  zone     = "us-south-1"
  capacity = 800
}

resource "ibm_is_volume" "db" {
  name     = "${var.BASENAME}-db"
  profile  = "5iops-tier"
  zone     = "us-south-1"
  capacity = 400
}
