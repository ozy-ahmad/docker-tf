# output "ip-address" {
#   value       = [for i in docker_container.nodered[*] : join(":", [i.ip_address], i.ports[*]["external"])]
#   description = "The IP address of the container and external port"
#   //sensitive = true
# }

# output "container-name" {
#   value       = docker_container.nodered.name
#   description = "THe name of the container"
# }

output "application_access" {
  value = { for x in docker_container.app_container[*] : x.name => join(":", [x.ip_address], x.ports[*]["external"]) }
}