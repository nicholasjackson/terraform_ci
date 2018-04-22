provider "digitalocean" {}

terraform {
  backend "s3" {
    bucket   = "tf-remote-state"
    region   = "us-east-1"
    endpoint = "https://nyc3.digitaloceanspaces.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-14-04-x64"
  name   = "web-1"
  region = "nyc3"
  size   = "512mb"
}
