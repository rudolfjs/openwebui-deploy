terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

locals {
  # If host_path is provided, create driver_opts for bind mount
  volume_driver_opts = var.host_path != "" ? merge(
    var.driver_opts,
    {
      "type"   = "none"
      "o"      = "bind"
      "device" = var.host_path
    }
  ) : var.driver_opts
}

resource "docker_volume" "volume" {
  name        = var.volume_name
  driver      = var.driver
  driver_opts = local.volume_driver_opts
  labels      = var.labels

  # Ensure the host directory exists if a host path is provided
  provisioner "local-exec" {
    command = var.host_path != "" ? "powershell New-Item -ItemType Directory -Force -Path \"${var.host_path}\"" : "echo No host path specified"
  }

  # Handle Windows paths properly
  lifecycle {
    precondition {
      condition     = var.host_path == "" || can(regex("^[A-Za-z]:\\\\", var.host_path)) || can(regex("^\\\\\\\\", var.host_path))
      error_message = "Host path must be a valid Windows path (e.g., C:\\path\\to\\volume or \\\\server\\share\\path)"
    }
  }
}
