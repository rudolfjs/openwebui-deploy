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
    "traefik.http.routers.pipelines.rule"                    = "PathPrefix(`/pipelines`)"
    "traefik.http.services.pipelines.loadbalancer.server.port" = "9099"
    "traefik.http.middlewares.nobuffer.buffering.disable"     = "true"
    "traefik.http.routers.pipelines.middlewares"             = "nobuffer"
    "traefik.http.middlewares.strip-pipelines.stripprefix.prefixes" = "/pipelines"
    "traefik.http.routers.pipelines.middlewares"             = "strip-pipelines,nobuffer"
  }

  # Combine base labels with any additional labels
  container_labels = merge(local.base_labels, var.additional_labels)

  # Add Cloudflare-specific labels if enabled
  cloudflare_labels = var.enable_cloudflare ? {
    "traefik.http.routers.pipelines.tls"                     = "true"
    "traefik.http.routers.pipelines.tls.certresolver"        = "cloudflare"
    "traefik.http.routers.pipelines.entrypoints"             = "websecure"
  } : {}

  # Final labels combining all sources
  final_labels = merge(local.container_labels, local.cloudflare_labels)
}

# Use the volumes module for pipelines data
module "pipelines_volume" {
  source = "../volumes"

  volume_name = var.volume_name
  host_path  = var.host_data_path
  labels = {
    "service" = "pipelines"
  }
}

# Pipelines container
resource "docker_container" "pipelines" {
  name  = var.container_name
  image = var.image

  # Mount the data volume
  volumes {
    volume_name    = module.pipelines_volume.volume_name
    container_path = "/app/pipelines"
  }

  # Add direct port mapping if enabled
  dynamic "ports" {
    for_each = var.enable_direct_port ? [1] : []
    content {
      internal = 9099
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
  env = var.additional_environment

  # Restart policy
  restart = var.restart_policy

  # Health check
  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost:9099/health"]
    interval     = "30s"
    timeout      = "10s"
    retries      = 3
    start_period = "30s"
  }
}
