provider "digitalocean" {}

terraform {
  backend "s3" {
    bucket   = "tf-remote-state"
    key      = "tide/terraform.tfstate"
    region   = "us-east-1"
    endpoint = "https://nyc3.digitaloceanspaces.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}

variable "instance_count" {
  default = 1
}

variable "region" {
  default = "nyc3"
}
