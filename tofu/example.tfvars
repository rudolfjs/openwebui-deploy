# Basic configuration
traefik_dashboard_port = 8080
traefik_http_port = 80

# Docker images
openwebui_image = "ghcr.io/open-webui/open-webui:git-f20b7c2"
pipelines_image = "ghcr.io/open-webui/pipelines:main"

# Custom volume paths
# Uncomment and modify these paths to store data in specific locations
volume_paths = {
  "open-webui" = "C:\\Data\\OpenWebUI"  # Windows path example
  "pipelines"  = "C:\\Data\\Pipelines"  # Windows path example
  # "open-webui" = "/data/openwebui"    # Linux path example
  # "pipelines"  = "/data/pipelines"    # Linux path example
}

# Cloudflare integration
# Uncomment and configure these values to enable Cloudflare integration
# enable_cloudflare = true
# cloudflare_domain = "openwebui.yourdomain.com"
# cloudflare_tunnel_name = "openwebui-tunnel"

# Additional configuration options
# Uncomment to customize the deployment
# traefik_dashboard_port = 8081       # Change Traefik dashboard port
# traefik_http_port = 8000            # Change HTTP port