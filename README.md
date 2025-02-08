<div align="center">

# Open WebUI Deployment

[![License](https://img.shields.io/github/license/your-name/your-repository?label=license&style=for-the-badge)](LICENSE)
[![Docker](https://img.shields.io/badge/docker-257bd6?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/)

</div>

Deployment of local Open WebUI
---

# Installation

This deployment only requires docker to be installed. 

Please see installation instructions [here](https://docs.docker.com/engine/install/).

# Deployment

To deploy the Open WebUI service and the `pipeline` service:

```bash
docker compose up -d
```

Once completed, you can access the web service on `localhost:3000`

# Configuration

1. Create administrator user

2. Add API Keys
    1. Install required `pipeline` repositories

3. Check connectivity


## Issues with Service

This is unrelated to the `docker-compose` deployment, but an issue with the services.

1. API key seems to corrupt when service goes offline.
    * Current workaround is to re-import the keys.





