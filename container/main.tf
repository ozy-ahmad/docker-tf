resource "random_string" "random" {
  count = var.count_in
  length  = 4
  special = false
  # count   = local.container_count
  upper   = false
}

resource "docker_container" "app_container" {
  name = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  count = var.count_in
  image = var.image_in
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }
  dynamic "volumes" {
  for_each = var.volumes_in
   content {
     container_path = volumes.value["container_path_each"]
    # host_path      = var.host_path_in
    volume_name = docker_volume.container_volume[volumes.key].name
   }
    
  }
  provisioner "local-exec" {
    command = "echo ${self.name}: ${self.ip_address}:${join("", [for x in self.ports[*]["external"]:x])} >> containers.txt"
  }
  provisioner "local-exec" {
    when = destroy
    command = "rm -f containers.txt" 
  }
}

resource "docker_volume" "container_volume" {
count = length(var.volumes_in)
  name = "${var.name_in}-${count.index}-volume"
  lifecycle {
    prevent_destroy = false 
  }
  provisioner "local-exec" {
    when = destroy
    command = "mkdir ${path.cwd}/../backup/"
    on_failure = continue
  }
  provisioner "local-exec" {
    when = destroy
    command = "sudo tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/ "
    on_failure = fail
  }
}