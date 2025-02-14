output "container_id" {
  description = "ID of the Pipelines container"
  value       = docker_container.pipelines.id
}

output "container_name" {
  description = "Name of the Pipelines container"
  value       = docker_container.pipelines.name
}

output "volume_name" {
  description = "Name of the Pipelines data volume"
  value       = module.pipelines_volume.volume_name
}

output "volume_mountpoint" {
  description = "Mountpoint of the Pipelines data volume"
  value       = module.pipelines_volume.volume_mountpoint
}

output "host_path" {
  description = "Host path for the Pipelines data (if configured)"
  value       = module.pipelines_volume.host_path
}

output "internal_port" {
  description = "Internal port of the Pipelines service"
  value       = 9099
}

output "external_port" {
  description = "External port of the Pipelines service (if direct port is enabled)"
  value       = var.enable_direct_port ? var.direct_port : null
}

output "service_url" {
  description = "URL path where the Pipelines service is available through Traefik"
  value       = "/pipelines"
}

output "healthcheck_endpoint" {
  description = "Health check endpoint for the Pipelines service"
  value       = "http://localhost:${var.enable_direct_port ? var.direct_port : 9099}/health"
}