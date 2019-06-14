resource "digitalocean_loadbalancer" "public" {
  name   = "${terraform.workspace}-loadbalancer"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}

resource "digitalocean_firewall" "web" {
  name = "${terraform.workspace}-only-22-80-and-443"

  droplet_ids = digitalocean_droplet.web.*.id

  dynamic "inbound_rule" {
    for_each = var.firewall_rules

    /*
    for_each = [for r in var.firewall_rules : {
      protocol         = trimspace(r.protocol)
      port_range       = r.port_range
      source_addresses = r.source_addresses
    }]
    */

    content {
      protocol         = inbound_rule.value.protocol
      port_range       = inbound_rule.value.port_range
      source_addresses = inbound_rule.value.source_addresses
    }
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

