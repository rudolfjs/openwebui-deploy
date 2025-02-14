# Network for all services
resource "docker_network" "traefik_public" {
  name = "traefik-public"
}

# Traefik Module
module "traefik" {
  source = "./modules/traefik"

  dashboard_port = var.traefik_dashboard_port
  http_port     = var.traefik_http_port
  network_name  = docker_network.traefik_public.name
  
  enable_cloudflare = var.enable_cloudflare
  enable_https     = var.enable_cloudflare
  
  environment = var.enable_cloudflare ? {
    CLOUDFLARE_EMAIL = var.cloudflare_domain # Will be used for Let's Encrypt
  } : {}
}

# Pipelines Module
module "pipelines" {
  source = "./modules/pipelines"

  image         = var.pipelines_image
  network_name  = docker_network.traefik_public.name
  volume_name   = "pipelines"
  host_data_path = lookup(var.volume_paths, "pipelines", "")
  
  enable_cloudflare = var.enable_cloudflare
  
  depends_on = [
    module.traefik
  ]
}

# OpenWebUI Module
module "openwebui" {
  source = "./modules/openwebui"

  image         = var.openwebui_image
  network_name  = docker_network.traefik_public.name
  volume_name   = "open-webui"
  host_data_path = lookup(var.volume_paths, "open-webui", "")
  
  pipelines_container_name = module.pipelines.container_name
  
  enable_cloudflare        = var.enable_cloudflare
  cloudflare_tunnel_enabled = var.enable_cloudflare
  cloudflare_domain        = var.cloudflare_domain
  
  depends_on = [
    module.pipelines
  ]
}

# Outputs for the complete stack
output "traefik_dashboard" {
  description = "Traefik Dashboard URL"
  value       = module.traefik.dashboard_url
}

output "openwebui_url" {
  description = "OpenWebUI URL"
  value       = var.enable_cloudflare ? "https://${var.cloudflare_domain}" : "http://localhost:${var.traefik_http_port}"
}

output "volume_paths" {
  description = "Configured volume paths"
  value = {
    "pipelines"  = module.pipelines.host_path
    "open-webui" = module.openwebui.host_path
  }
}

output "containers" {
  description = "Container information"
  value = {
    traefik = {
      name = module.traefik.container_name
      id   = module.traefik.container_id
    }
    pipelines = {
      name = module.pipelines.container_name
      id   = module.pipelines.container_id
    }
    openwebui = {
      name = module.openwebui.container_name
      id   = module.openwebui.container_id
    }
  }
}

output "cloudflare_status" {
  description = "Cloudflare integration status"
  value = {
    enabled = var.enable_cloudflare
    domain  = var.cloudflare_domain
  }
}