variable "dashboard_port" {
  type        = number
  description = "Port for Traefik dashboard"
  default     = 8080
}

variable "http_port" {
  type        = number
  description = "Port for HTTP traffic"
  default     = 80
}

variable "network_name" {
  type        = string
  description = "Name of the Docker network to use"
  default     = "traefik-public"
}

variable "container_name" {
  type        = string
  description = "Name of the Traefik container"
  default     = "traefik"
}

variable "enable_cloudflare" {
  type        = bool
  description = "Enable Cloudflare integration configurations"
  default     = false
}

variable "additional_commands" {
  type        = list(string)
  description = "Additional Traefik commands"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Additional labels for the Traefik container"
  default     = {}
}

variable "environment" {
  type        = map(string)
  description = "Environment variables for the Traefik container"
  default     = {}
}

# Future Cloudflare-specific variables
variable "cloudflare_certificates_resolver" {
  type        = string
  description = "Name of the Cloudflare certificates resolver"
  default     = "cloudflare"
}

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS entrypoint"
  default     = false
}

variable "https_port" {
  type        = number
  description = "Port for HTTPS traffic"
  default     = 443
}