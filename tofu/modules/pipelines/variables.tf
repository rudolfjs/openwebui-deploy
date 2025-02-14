variable "image" {
  type        = string
  description = "Pipelines Docker image"
  default     = "ghcr.io/open-webui/pipelines:main"
}

variable "container_name" {
  type        = string
  description = "Name of the Pipelines container"
  default     = "pipelines"
}

variable "network_name" {
  type        = string
  description = "Name of the Docker network to join"
}

variable "volume_name" {
  type        = string
  description = "Name of the volume to use for pipelines data"
}

variable "enable_cloudflare" {
  type        = bool
  description = "Whether Cloudflare integration is enabled"
  default     = false
}

variable "additional_labels" {
  type        = map(string)
  description = "Additional labels for the Pipelines container"
  default     = {}
}

variable "additional_environment" {
  type        = map(string)
  description = "Additional environment variables for the Pipelines container"
  default     = {}
}

variable "host_data_path" {
  type        = string
  description = "Host path for pipelines data volume"
  default     = ""
}

variable "enable_direct_port" {
  type        = bool
  description = "Whether to expose the Pipelines port directly"
  default     = false
}

variable "direct_port" {
  type        = number
  description = "Port to expose Pipelines on if direct port is enabled"
  default     = 9099
}

variable "restart_policy" {
  type        = string
  description = "Container restart policy"
  default     = "always"
}