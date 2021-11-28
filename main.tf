
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

//this is image hardcode
# resource "docker_image" "nodered_image" {
#   name = var.image[terraform.workspace]

# }

//This is module for image
module "image" {
  source = "./image"
}

resource "random_string" "random" {
  length  = 4
  special = false
  count   = local.container_count
  upper   = false
}


resource "docker_container" "nodered" {
  count = local.container_count
  //this is how image refence without using  module
  #image = docker_image.nodered_image.latest
  
  //this is how image referenced using module
  image = module.image.image_out
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

