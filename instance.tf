resource "digitalocean_volume" "data" {
  count       = var.instance_count
  region      = var.region
  name        = "dev-${count.index}-data"
  size        = 100
  description = "an example volume"
}

resource "digitalocean_droplet" "web" {
  count  = var.instance_count
  region = var.region
  image  = "ubuntu-14-04-x64"
  name   = "dev-${count.index}-web"
  size   = "512mb"

  volume_ids = [element(digitalocean_volume.data.*.id, count.index)]
}

