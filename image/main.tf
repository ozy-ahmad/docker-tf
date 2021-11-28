resource "docker_image" "nodered_image" {
  #   name = var.image[terraform.workspace]
  name = "nodered/node-red:latest"
}