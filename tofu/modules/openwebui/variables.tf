variable "image" {
  type        = string
  description = "OpenWebUI Docker image"
  default     = "ghcr.io/open-webui/open-webui:git-f20b7c2"
}

variable "container_name" {
  type        = string
  description = "Name of the OpenWebUI container"
  default     = "openwebui"
}

variable "network_name" {
  type        = string
  description = "Name of the Docker network to join"
}

variable "volume_name" {
  type        = string
  description = "Name of the volume to use for OpenWebUI data"
}

variable "pipelines_container_name" {
  type        = string
  description = "Name of the Pipelines container to connect to"
}

variable "enable_cloudflare" {
  type        = bool
  description = "Whether Cloudflare integration is enabled"
  default     = false
}

variable "additional_labels" {
  type        = map(string)
  description = "Additional labels for the OpenWebUI container"
  default     = {}
}

variable "additional_environment" {
  type        = map(string)
  description = "Additional environment variables for the OpenWebUI container"
  default     = {}
}

variable "host_data_path" {
  type        = string
  description = "Host path for OpenWebUI data volume"
  default     = ""
}

variable "restart_policy" {
  type        = string
  description = "Container restart policy"
  default     = "always"
}

variable "internal_port" {
  type        = number
  description = "Internal port for the OpenWebUI service"
  default     = 8080
}

variable "enable_direct_port" {
  type        = bool
  description = "Whether to expose the OpenWebUI port directly"
  default     = false
}

variable "direct_port" {
  type        = number
  description = "Port to expose OpenWebUI on if direct port is enabled"
  default     = 8080
}

variable "cloudflare_tunnel_enabled" {
  type        = bool
  description = "Whether to configure for Cloudflare Tunnel"
  default     = false
}

variable "cloudflare_domain" {
  type        = string
  description = "Domain name for Cloudflare configuration"
  default     = ""
}