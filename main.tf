terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

resource "docker_image" "nodered_image" {
  name = var.image[terraform.workspace]

}

resource "random_string" "random" {
  length  = 4
  special = false
  count   = local.container_count
  upper   = false
}


resource "docker_container" "nodered" {
  count = local.container_count
  image = docker_image.nodered_image.latest
  name  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  ports {
    internal = var.int_port
    external = var.ext_port[terraform.workspace][count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/noderedvol"
  }
}

