# output "IP-Address" {
#   value       = flatten(module.container[*].ip-address)
#   description = "The IP address of the container and external port"
#   //sensitive = true
# }

# output "Container-name" {
#   value       = module.container[*].container-name
#   description = "THe name of the container"
# }