resource "digitalocean_volume" "data" {
  count       = var.instance_count
  region      = var.region
  name        = "${terraform.workspace}-${count.index}-data1"
  size        = 100
  description = "an example volume"
}

resource "digitalocean_droplet" "web" {
  count  = var.instance_count
  region = var.region
  image  = "ubuntu-14-04-x64"
  name   = "${terraform.workspace}-${count.index}-web"
  size   = "512mb"

  volume_ids = [element(digitalocean_volume.data.*.id, count.index)]
}

