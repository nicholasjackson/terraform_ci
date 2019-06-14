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

variable "firewall_rules" {
  default = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}
