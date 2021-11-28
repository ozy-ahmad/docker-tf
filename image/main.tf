resource "docker_image" "container_image" {
  #   name = var.image[terraform.workspace]
  name = var.image_in
}