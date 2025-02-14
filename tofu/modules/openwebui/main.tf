terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

locals {
  base_labels = {
    "traefik.enable"                                          = "true"
    "traefik.http.routers.openwebui.rule"                    = "PathPrefix(`/`)"
    "traefik.http.services.openwebui.loadbalancer.server.port" = tostring(var.internal_port)
    "traefik.http.middlewares.sslheader.headers.customrequestheaders.X-Forwarded-Proto" = "https"
    "traefik.http.routers.openwebui.middlewares"             = "sslheader"
  }

  # Combine base labels with any additional labels
  container_labels = merge(local.base_labels, var.additional_labels)

  # Add Cloudflare-specific labels if enabled
  cloudflare_labels = var.enable_cloudflare ? {
    "traefik.http.routers.openwebui.tls"                     = "true"
    "traefik.http.routers.openwebui.tls.certresolver"        = "cloudflare"
    "traefik.http.routers.openwebui.entrypoints"             = "websecure"
  } : {}

  # Final labels combining all sources
  final_labels = merge(local.container_labels, local.cloudflare_labels)

  # Base environment variables
  base_environment = {
    "PIPELINE_URL" = "http://${var.pipelines_container_name}:9099"
  }

  # Cloudflare-specific environment variables
  cloudflare_environment = var.cloudflare_tunnel_enabled ? {
    "CLOUDFLARE_DOMAIN" = var.cloudflare_domain
  } : {}

  # Final environment variables
  final_environment = merge(local.base_environment, local.cloudflare_environment, var.additional_environment)
}

# Use the volumes module for OpenWebUI data
module "openwebui_volume" {
  source = "../volumes"

  volume_name = var.volume_name
  host_path  = var.host_data_path
  labels = {
    "service" = "openwebui"
  }
}

# OpenWebUI container
resource "docker_container" "openwebui" {
  name  = var.container_name
  image = var.image

  # Mount the data volume
  volumes {
    volume_name    = module.openwebui_volume.volume_name
    container_path = "/app/backend/data"
  }

  # Add direct port mapping if enabled
  dynamic "ports" {
    for_each = var.enable_direct_port ? [1] : []
    content {
      internal = var.internal_port
      external = var.direct_port
    }
  }

  # Network configuration
  networks_advanced {
    name = var.network_name
  }

  # Host configurations
  extra_hosts = ["host.docker.internal:host-gateway"]

  # Labels for Traefik integration
  labels = local.final_labels

  # Environment variables
  env = local.final_environment

  # Restart policy
  restart = var.restart_policy

  # Dependencies
  depends_on = [
    # This ensures the Pipelines service is available
    var.pipelines_container_name
  ]

  # Health check
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:${var.internal_port}/health"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "30s"
  }

  # Windows-specific configurations
  dynamic "devices" {
    for_each = can(regex("^Windows", terraform.workspace)) ? [1] : []
    content {
      host_path      = "//./pipe/docker_engine"
      container_path = "/var/run/docker.sock"
    }
  }
}
