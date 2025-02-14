variable "volume_paths" {
  type        = map(string)
  description = "Map of volume names to host paths"
  default     = {}
}

variable "traefik_dashboard_port" {
  type        = number
  description = "Port for Traefik dashboard"
  default     = 8080
}

variable "traefik_http_port" {
  type        = number
  description = "Port for HTTP traffic"
  default     = 80
}

variable "openwebui_image" {
  type        = string
  description = "OpenWebUI Docker image"
  default     = "ghcr.io/open-webui/open-webui:git-f20b7c2"
}

variable "pipelines_image" {
  type        = string
  description = "Pipelines Docker image"
  default     = "ghcr.io/open-webui/pipelines:main"
}

# Future Cloudflare variables
variable "enable_cloudflare" {
  type        = bool
  description = "Enable Cloudflare integration"
  default     = false
}

variable "cloudflare_domain" {
  type        = string
  description = "Domain name for Cloudflare configuration"
  default     = ""
}

variable "cloudflare_tunnel_name" {
  type        = string
  description = "Name for the Cloudflare tunnel"
  default     = ""
}

# variable "cloudflare_api_token" {
#   type        = string
#   description = "Cloudflare API token"
#   sensitive   = true
# }