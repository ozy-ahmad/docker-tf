# output "IP-Address" {
#   value       = flatten(module.container[*].ip-address)
#   description = "The IP address of the container and external port"
#   //sensitive = true
# }

# output "Container-name" {
#   value       = module.container[*].container-name
#   description = "THe name of the container"
# }

output "application_access" {
  // for loop is not necessary, use module.container for simplicity
  #value= [for x in module.container[*]: x]
  value       = module.container
  description = "The name and socket for each application."
}