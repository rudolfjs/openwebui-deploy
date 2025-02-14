terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

locals {
  base_commands = [
    "--api.insecure=true",
    "--api.dashboard=true",
    "--providers.docker=true",
    "--providers.docker.exposedbydefault=false",
    "--entrypoints.web.address=:80",
    "--entrypoints.web.transport.lifecycle.gracetimeout=30s",
    "--ping=true"
  ]

  # Cloudflare-specific commands
  cloudflare_commands = var.enable_cloudflare && var.enable_https ? [
    "--entrypoints.websecure.address=:443",
    "--certificatesresolvers.${var.cloudflare_certificates_resolver}.acme.email=${var.environment["CLOUDFLARE_EMAIL"]}",
    "--certificatesresolvers.${var.cloudflare_certificates_resolver}.acme.storage=/letsencrypt/acme.json",
    "--certificatesresolvers.${var.cloudflare_certificates_resolver}.acme.dnschallenge=true",
    "--certificatesresolvers.${var.cloudflare_certificates_resolver}.acme.dnschallenge.provider=cloudflare"
  ] : []

  # Combine all commands
  commands = concat(local.base_commands, local.cloudflare_commands, var.additional_commands)

  # Base ports
  base_ports = [
    "${var.http_port}:80",
    "${var.dashboard_port}:8080"
  ]

  # Add HTTPS port if enabled
  ports = var.enable_https ? concat(local.base_ports, ["${var.https_port}:443"]) : local.base_ports

  # Combine base and custom labels
  labels = merge(
    {
      "traefik.enable" = "true"
    },
    var.labels
  )
}

# Create the Traefik network if it doesn't exist
resource "docker_network" "traefik_network" {
  name = var.network_name
  driver = "bridge"
}

# Traefik container
resource "docker_container" "traefik" {
  name  = var.container_name
  image = "traefik:v2.10"

  command = local.commands

  ports {
    internal = 80
    external = var.http_port
  }

  ports {
    internal = 8080
    external = var.dashboard_port
  }

  dynamic "ports" {
    for_each = var.enable_https ? [1] : []
    content {
      internal = 443
      external = var.https_port
    }
  }

  volumes {
    container_path = "/var/run/docker.sock"
    host_path      = "/var/run/docker.sock"
    read_only      = true
  }

  # Add volume for SSL certificates if Cloudflare is enabled
  dynamic "volumes" {
    for_each = var.enable_cloudflare && var.enable_https ? [1] : []
    content {
      container_path = "/letsencrypt"
      host_path      = "letsencrypt"
    }
  }

  networks_advanced {
    name = docker_network.traefik_network.name
  }

  labels = local.labels

  env = var.environment

  restart = "always"

  # Windows-specific socket path
  dynamic "volumes" {
    for_each = can(regex("^Windows", terraform.workspace)) ? [1] : []
    content {
      container_path = "/var/run/docker.sock"
      host_path      = "//./pipe/docker_engine"
      read_only      = true
    }
  }
}
