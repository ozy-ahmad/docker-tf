resource "docker_container" "nodered" {
  name = var.name_in

  image = var.image_in
  ports {
    internal = var.int_port_in
    external = var.ext_port_in
  }
  volumes {
    container_path = var.container_path_in
    # host_path      = var.host_path_in
    volume_name = docker_volume.container_volume.name
  }
}

resource "docker_volume" "container_volume" {
  name = "${var.name_in}-name"
}