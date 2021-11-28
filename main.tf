
# resource "null_resource" "dockervol" {
#   provisioner "local-exec" {
#     command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
#   }
# }

//this is image hardcode
# resource "docker_image" "nodered_image" {
#   name = var.image[terraform.workspace]

# }

//This is module for image
module "image" {
  source = "./image"
  image_in = var.image[terraform.workspace]
}

resource "random_string" "random" {
  length  = 4
  special = false
  count   = local.container_count
  upper   = false
}


module "container" {
source = "./container"
//explicit dependencies
# depends_on = [null_resource.dockervol]
  
  //implicit dependencies
  # name  = join("-", ["nodered", terraform.workspace, null_resource.dockervol.id random_string.random[count.index].result])
  count = local.container_count
  
  name_in  = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  //this is how image refence without using  module
  #image = docker_image.nodered_image.latest
  
  //this is how image referenced using module
  image_in = module.image.image_out

    int_port_in = var.int_port
    ext_port_in = var.ext_port[terraform.workspace][count.index]
    container_path_in = "/data"
    host_path_in      = "${path.cwd}/noderedvol"
  
}

