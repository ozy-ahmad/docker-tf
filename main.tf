
# resource "null_resource" "dockervol" {
#   provisioner "local-exec" {
#     command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
#   }
# }

//this is image hardcode
# resource "docker_image" "nodered_image" {
#   name = var.image[terraform.workspace]

# }

locals {
  deployment = {
    nodered = {
     container_count = length(var.ext_port["nodered"][terraform.workspace])
      image = var.image["nodered"][terraform.workspace]
      int = 1880
      ext = var.ext_port["nodered"][terraform.workspace]
      container_path = "/data"
    }
    influxdb = {
    container_count = length(var.ext_port["influxdb"][terraform.workspace])
      image = var.image["influxdb"][terraform.workspace]
      int = 8086
      ext = var.ext_port["influxdb"][terraform.workspace]
      container_path = "/var/lib/influxdb"
    }
  }
}

//This is module for image
module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image
}


module "container" {
  source = "./container"
  
  //explicit dependencies
  # depends_on = [null_resource.dockervol]

  //implicit dependencies
  # name  = join("-", ["nodered", terraform.workspace, null_resource.dockervol.id random_string.random[count.index].result])
  //number of conainer will be created but we changed it using for_each
  # count = local.container_count
  count_in = each.value.container_count
  for_each = local.deployment
  name_in = each.key
  //this is how image refence without using  module
  #image = docker_image.nodered_image.latest
  
  //this is how image referenced using module
  image_in = module.image[each.key].image_out
  int_port_in       = each.value.int
  ext_port_in       = each.value.ext
  container_path_in = each.value.container_path

}

