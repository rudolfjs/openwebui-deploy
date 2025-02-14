output "volume_name" {
  description = "Name of the created Docker volume"
  value       = docker_volume.volume.name
}

output "volume_driver" {
  description = "Driver used for the Docker volume"
  value       = docker_volume.volume.driver
}

output "volume_mountpoint" {
  description = "Mountpoint of the Docker volume"
  value       = docker_volume.volume.mountpoint
}

output "host_path" {
  description = "Host path if provided"
  value       = var.host_path
}