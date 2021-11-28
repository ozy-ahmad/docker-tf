resource "random_string" "random" {
  count = var.count_in
  length  = 4
  special = false
  # count   = local.container_count
  upper   = false
}

resource "docker_container" "nodered" {
  name = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  count = var.count_in
  image = var.image_in
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }
  volumes {
    container_path = var.container_path_in
    # host_path      = var.host_path_in
    volume_name = docker_volume.container_volume[count.index].name
  }
}

resource "docker_volume" "container_volume" {
count = var.count_in
  name = "${var.name_in}-${random_string.random[count.index].result}-volume"
  lifecycle {
    prevent_destroy = false 
  }
}