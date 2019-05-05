variable "billing_account" {}
variable "org_id" {}

provider "google" {
  credentials = "${file("${var.keyfile}")}"    
  project = "${var.project_name}"
  region  = "${var.region_a}"
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  name = "${var.project_name}"

  project_id      = "${random_id.id.hex}"
  #project_id      = "${var.project_id}"
  billing_account = "${var.billing_account}"

  folder_id = "571739382967"

  lifecycle = {
    prevent_destroy = true
  }
}

#resource "google_folder" "terraform_projects" {
#  display_name = "terraform_projects"
#  parent       = "571739382967"
#}

resource "google_project_services" "project" {
  project = "${google_project.project.project_id}"

  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

output "project_id" {
  value = "${google_project.project.project_id}"
}
