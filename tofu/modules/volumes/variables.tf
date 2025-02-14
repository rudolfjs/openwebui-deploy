variable "volume_name" {
  type        = string
  description = "Name of the Docker volume"
}

variable "host_path" {
  type        = string
  description = "Optional host path for the volume"
  default     = ""
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the volume"
  default     = {}
}

variable "driver" {
  type        = string
  description = "Volume driver to use"
  default     = "local"
}

variable "driver_opts" {
  type        = map(string)
  description = "Driver-specific options"
  default     = {}
}