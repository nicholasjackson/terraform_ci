provider "digitalocean" {
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pinkyandthebrain"

    workspaces {
      prefix = "terraform_ci"
    }
  }
}

variable "instance_count" {
  default = 1
}

variable "region" {
  default = "nyc3"
}
