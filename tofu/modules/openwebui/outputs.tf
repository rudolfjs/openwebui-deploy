output "container_id" {
  description = "ID of the OpenWebUI container"
  value       = docker_container.openwebui.id
}

output "container_name" {
  description = "Name of the OpenWebUI container"
  value       = docker_container.openwebui.name
}

output "volume_name" {
  description = "Name of the OpenWebUI data volume"
  value       = module.openwebui_volume.volume_name
}

output "volume_mountpoint" {
  description = "Mountpoint of the OpenWebUI data volume"
  value       = module.openwebui_volume.volume_mountpoint
}

output "host_path" {
  description = "Host path for the OpenWebUI data (if configured)"
  value       = module.openwebui_volume.host_path
}

output "internal_port" {
  description = "Internal port of the OpenWebUI service"
  value       = var.internal_port
}

output "external_port" {
  description = "External port of the OpenWebUI service (if direct port is enabled)"
  value       = var.enable_direct_port ? var.direct_port : null
}

output "service_url" {
  description = "URL path where the OpenWebUI service is available through Traefik"
  value       = "/"
}

output "healthcheck_endpoint" {
  description = "Health check endpoint for the OpenWebUI service"
  value       = "http://localhost:${var.enable_direct_port ? var.direct_port : var.internal_port}/health"
}

output "cloudflare_enabled" {
  description = "Whether Cloudflare integration is enabled"
  value       = var.enable_cloudflare
}

output "cloudflare_tunnel_enabled" {
  description = "Whether Cloudflare Tunnel is enabled"
  value       = var.cloudflare_tunnel_enabled
}

output "cloudflare_domain" {
  description = "Cloudflare domain (if configured)"
  value       = var.cloudflare_domain
}