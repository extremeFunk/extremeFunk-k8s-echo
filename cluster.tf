provider "google" {
  credentials = "${file("${var.credentials_file_path}")}"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.region_zone}"
}

resource "google_container_cluster" "primary" {
  name     = "echo-cluster"
  location = "${var.region}"
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "echo-node-pool"
  location   = "${var.region}"

  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
