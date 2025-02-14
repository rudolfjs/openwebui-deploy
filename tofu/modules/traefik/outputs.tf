output "network_id" {
  description = "ID of the created Traefik network"
  value       = docker_network.traefik_network.id
}

output "network_name" {
  description = "Name of the created Traefik network"
  value       = docker_network.traefik_network.name
}

output "container_id" {
  description = "ID of the Traefik container"
  value       = docker_container.traefik.id
}

output "container_name" {
  description = "Name of the Traefik container"
  value       = docker_container.traefik.name
}

output "dashboard_url" {
  description = "URL for the Traefik dashboard"
  value       = "http://localhost:${var.dashboard_port}"
}

output "http_port" {
  description = "External HTTP port"
  value       = var.http_port
}

output "https_enabled" {
  description = "Whether HTTPS is enabled"
  value       = var.enable_https
}

output "https_port" {
  description = "External HTTPS port (if enabled)"
  value       = var.enable_https ? var.https_port : null
}

output "cloudflare_enabled" {
  description = "Whether Cloudflare integration is enabled"
  value       = var.enable_cloudflare
}