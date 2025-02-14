# OpenWebUI Terraform/OpenTofu Configuration

This directory contains the Terraform/OpenTofu configuration for deploying OpenWebUI with Traefik and Pipelines services. The configuration is modular and supports custom volume paths and Cloudflare integration.

## Prerequisites

- OpenTofu/Terraform installed
- Docker installed and running
- If using Cloudflare integration:
  - Cloudflare account
  - Domain configured in Cloudflare
  - API token with appropriate permissions

## Module Structure

```
tofu/
├── main.tf           # Main configuration
├── variables.tf      # Input variables
├── providers.tf      # Provider configurations
└── modules/
    ├── traefik/     # Traefik reverse proxy
    ├── pipelines/   # Pipelines service
    ├── openwebui/   # OpenWebUI service
    └── volumes/     # Volume management
```

## Usage

1. Initialize the working directory:
```bash
tofu init
```

2. Create a `terraform.tfvars` file with your configuration:
```hcl
# Basic configuration with default volume locations
volume_paths = {}
traefik_dashboard_port = 8080
traefik_http_port = 80

# Configuration with custom volume paths
volume_paths = {
  "open-webui" = "C:\\Data\\OpenWebUI"
  "pipelines"  = "C:\\Data\\Pipelines"
}

# Configuration with Cloudflare integration
enable_cloudflare = true
cloudflare_domain = "openwebui.yourdomain.com"
cloudflare_tunnel_name = "openwebui-tunnel"
```

3. Review the planned changes:
```bash
tofu plan
```

4. Apply the configuration:
```bash
tofu apply
```

## Volume Configuration

The configuration supports custom volume paths through the `volume_paths` variable. This allows you to specify where the data for each service should be stored on the host system:

```hcl
volume_paths = {
  "open-webui" = "C:\\Data\\OpenWebUI"  # Windows path
  "pipelines"  = "C:\\Data\\Pipelines"  # Windows path
}
```

If no paths are specified, Docker will manage the volumes with default locations.

## Cloudflare Integration

To enable Cloudflare integration:

1. Set `enable_cloudflare = true`
2. Provide your domain in `cloudflare_domain`
3. Configure the tunnel name in `cloudflare_tunnel_name`

Example configuration with Cloudflare:

```hcl
enable_cloudflare     = true
cloudflare_domain     = "openwebui.yourdomain.com"
cloudflare_tunnel_name = "openwebui-tunnel"
```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| volume_paths | Map of volume names to host paths | map(string) | {} |
| traefik_dashboard_port | Port for Traefik dashboard | number | 8080 |
| traefik_http_port | Port for HTTP traffic | number | 80 |
| openwebui_image | OpenWebUI Docker image | string | "ghcr.io/open-webui/open-webui:git-f20b7c2" |
| pipelines_image | Pipelines Docker image | string | "ghcr.io/open-webui/pipelines:main" |
| enable_cloudflare | Enable Cloudflare integration | bool | false |
| cloudflare_domain | Domain for Cloudflare configuration | string | "" |
| cloudflare_tunnel_name | Name for Cloudflare tunnel | string | "" |

## Outputs

| Name | Description |
|------|-------------|
| traefik_dashboard | Traefik Dashboard URL |
| openwebui_url | OpenWebUI URL (with or without Cloudflare) |
| volume_paths | Configured volume paths |
| containers | Container information (names and IDs) |
| cloudflare_status | Cloudflare integration status |

## Destroying Resources

To remove all created resources:

```bash
tofu destroy
```

Note: This will not delete the data in your volumes if you've configured custom paths.

## Troubleshooting

1. **Volume Permissions**: Ensure the specified host paths have appropriate permissions for Docker to read/write.

2. **Network Issues**: If services can't communicate, verify the Docker network creation was successful.

3. **Cloudflare Connection**: If using Cloudflare, ensure your API token has the necessary permissions and the domain is properly configured.

4. **Windows Paths**: When specifying Windows paths, use double backslashes: `C:\\path\\to\\volume`