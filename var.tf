variable "project" {
  default       = "$GCP_PROJECT"
}

variable "credentials_file_path" {
  default       = "gcp_crd.json"
}

variable "region" {
  default = "us-central1"
}

variable "region_zone" {
  default = "us-central1-f"
}