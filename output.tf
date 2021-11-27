output "IP-Address" {
  value       = [for i in docker_container.nodered[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "The IP address of the container and external port"
  //sensitive = true
}

output "Container-name" {
  value       = docker_container.nodered[*].name
  description = "THe name of the container"
}