# Docker Images for Ubuntu

[![Docker](https://img.shields.io/github/actions/workflow/status/snowdreamtech/ubuntu/docker.yml?branch=main&label=Docker&logo=github)](https://github.com/snowdreamtech/ubuntu/actions/workflows/docker.yml)
[![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/ubuntu/latest?logo=docker)](https://hub.docker.com/r/snowdreamtech/ubuntu)
[![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/ubuntu?logo=docker)](https://hub.docker.com/r/snowdreamtech/ubuntu)
[![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/ubuntu?logo=docker)](https://hub.docker.com/r/snowdreamtech/ubuntu)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)

[English](README.md) | [简体中文](README_zh-CN.md)

Production-ready Ubuntu Docker images with multi-platform support, comprehensive tooling, and security features.

## 🌟 Features

- **Multi-Version Support**: Ubuntu 22.04 (Jammy), 24.04 (Noble), 25.10 (Questing), 26.04 (Resolute)
- **Multi-Platform**: Supports amd64, arm64, armhf, ppc64le, s390x, and riscv64 (24.04+)
- **Multi-Registry**: Available on DockerHub, GitHub Container Registry (GHCR), and Quay.io
- **Essential Tooling**: Pre-installed curl, git, vim, jq, gosu, and network utilities
- **Flexible User Management**: Support for custom PUID/PGID and non-root execution
- **Modular Entrypoint**: Extensible initialization system via entrypoint.d/ scripts
- **Security First**: Vulnerability scanning, SBOM generation, provenance attestation, and image signing
- **Debug Support**: Conditional debug logging via DEBUG environment variable

## 📦 Supported Versions

| Version | Codename | Ubuntu Release | Architectures | Status |
|---------|----------|----------------|---------------|--------|
| 22      | jammy    | 22.04 LTS      | 5 platforms   | ✅ Supported |
| 24      | noble    | 24.04 LTS      | 6 platforms   | ✅ Latest |
| 25      | questing | 25.10          | 6 platforms   | ✅ Supported |
| 26      | resolute | 26.04 LTS      | 6 platforms   | ✅ Supported |

### Architecture Support

- **Ubuntu 22.04 (Jammy)**: linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x
- **Ubuntu 24.04+ (Noble/Questing/Resolute)**: linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64

> **Note**: RISC-V (riscv64) support was added starting with Ubuntu 24.04.

## 🚀 Quick Start

### Pull from DockerHub

```bash
# Latest version (24.04 Noble)
docker pull snowdreamtech/ubuntu:latest

# Specific version by number
docker pull snowdreamtech/ubuntu:22-latest
docker pull snowdreamtech/ubuntu:24-latest

# Specific version by codename
docker pull snowdreamtech/ubuntu:jammy
docker pull snowdreamtech/ubuntu:noble
docker pull snowdreamtech/ubuntu:questing
docker pull snowdreamtech/ubuntu:resolute
```

### Pull from GitHub Container Registry

```bash
docker pull ghcr.io/snowdreamtech/ubuntu:latest
docker pull ghcr.io/snowdreamtech/ubuntu:24-latest
docker pull ghcr.io/snowdreamtech/ubuntu:noble
```

### Pull from Quay.io

```bash
docker pull quay.io/snowdreamtech/ubuntu:latest
docker pull quay.io/snowdreamtech/ubuntu:24-latest
docker pull quay.io/snowdreamtech/ubuntu:noble
```

### Run a Container

```bash
# Basic usage
docker run --rm -it snowdreamtech/ubuntu:latest bash

# With custom user (non-root)
docker run --rm -it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  snowdreamtech/ubuntu:latest bash

# With debug logging
docker run --rm -it \
  -e DEBUG=true \
  snowdreamtech/ubuntu:latest bash

# With custom timezone
docker run --rm -it \
  -e TZ=Asia/Shanghai \
  snowdreamtech/ubuntu:latest bash

# With custom working directory
docker run --rm -it \
  -e WORKDIR=/app \
  -v $(pwd):/app \
  snowdreamtech/ubuntu:latest bash
```

## 🏷️ Image Tags

### Tag Naming Convention

| Tag Pattern | Description | Example |
|-------------|-------------|---------|
| `latest` | Latest stable version (24.04) | `snowdreamtech/ubuntu:latest` |
| `{version}-latest` | Latest build for specific version | `22-latest`, `24-latest` |
| `{codename}` | Ubuntu codename | `jammy`, `noble`, `questing`, `resolute` |
| `{codename}-latest` | Latest build for codename | `jammy-latest`, `noble-latest` |
| `{version}-{branch}` | Branch builds | `22-dev`, `24-main` |
| `{version}-nightly` | Nightly builds | `22-nightly`, `24-nightly` |
| `{version}-YYYYMMDD` | Date-tagged builds | `22-20250115`, `24-20250115` |
| `{version}.{minor}.{patch}` | Semantic version | `22.04.0`, `24.04.0` |

### Version Mapping

| Short Version | Full Version | Codename |
|---------------|--------------|----------|
| 22            | 22.04        | jammy    |
| 24            | 24.04        | noble    |
| 25            | 25.10        | questing |
| 26            | 26.04        | resolute |

## 🔧 Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DEBUG` | `false` | Enable debug logging for entrypoint scripts |
| `PUID` | `0` | User ID for non-root execution |
| `PGID` | `0` | Group ID for non-root execution |
| `USER` | `root` | Username for non-root execution |
| `WORKDIR` | `/root` | Working directory inside container |
| `TZ` | System default | Timezone (e.g., `Asia/Shanghai`, `America/New_York`) |
| `LANG` | `C.UTF-8` | Locale setting |
| `DEBIAN_FRONTEND` | `noninteractive` | Suppress interactive prompts during package installation |

## 📁 Project Structure

```text
ubuntu/
├── docker/
│   ├── 22/                         # Ubuntu 22.04 (Jammy)
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   └── entrypoint.d/
│   │       ├── 00-base-init.sh
│   │       ├── 01-base-setup.sh
│   │       └── 99-base-end.sh
│   ├── 24/                         # Ubuntu 24.04 (Noble)
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   └── entrypoint.d/
│   ├── 25/                         # Ubuntu 25.10 (Questing)
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   └── entrypoint.d/
│   └── 26/                         # Ubuntu 26.04 (Resolute)
│       ├── Dockerfile
│       ├── docker-entrypoint.sh
│       └── entrypoint.d/
└── .github/
    └── workflows/
        └── docker.yml              # Multi-platform build workflow
```

## 🛠️ Building Locally

### Prerequisites

- Docker with Buildx support
- QEMU for multi-platform builds (optional)

### Build a Specific Version

```bash
# Build Ubuntu 22.04
docker build -t ubuntu-local:22 docker/22/

# Build Ubuntu 24.04
docker build -t ubuntu-local:24 docker/24/

# Build Ubuntu 25.10
docker build -t ubuntu-local:25 docker/25/

# Build Ubuntu 26.04
docker build -t ubuntu-local:26 docker/26/
```

### Build Multi-Platform Images

```bash
# Set up buildx builder
docker buildx create --name multiplatform --use

# Build for multiple platforms (Ubuntu 24.04)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64 \
  -t ubuntu-local:24 \
  docker/24/

# Build for multiple platforms (Ubuntu 22.04 - no riscv64)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x \
  -t ubuntu-local:22 \
  docker/22/
```

## 🔐 Security Features

- **Vulnerability Scanning**: All images are scanned with Trivy for CRITICAL and HIGH severity vulnerabilities
- **SBOM Generation**: Software Bill of Materials (SBOM) in CycloneDX format attached to all images
- **Provenance Attestation**: SLSA provenance metadata for supply chain security
- **Image Signing**: All images are signed with Cosign using keyless OIDC
- **Egress Audit**: GitHub Actions workflow uses Harden Runner for network egress monitoring

## 📝 Usage Examples

### As a Base Image

```dockerfile
FROM snowdreamtech/ubuntu:24-latest

# Install additional packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Copy application
COPY . /app
WORKDIR /app

# Run application
CMD ["python3", "app.py"]
```

### With Docker Compose

```yaml
version: '3.8'

services:
  app:
    image: snowdreamtech/ubuntu:24-latest
    environment:
      - DEBUG=false
      - TZ=Asia/Shanghai
      - PUID=1000
      - PGID=1000
      - USER=appuser
      - WORKDIR=/app
    volumes:
      - ./app:/app
    command: bash -c "cd /app && ./run.sh"
```

### Extending Entrypoint Scripts

Add custom initialization scripts to the `entrypoint.d/` directory:

```dockerfile
FROM snowdreamtech/ubuntu:24-latest

# Add custom initialization script
COPY my-custom-init.sh /usr/local/bin/entrypoint.d/50-custom-init.sh
RUN chmod +x /usr/local/bin/entrypoint.d/50-custom-init.sh
```

Scripts in `entrypoint.d/` are executed in lexicographic order:
- `00-base-init.sh` - Early initialization
- `01-base-setup.sh` - Configuration setup
- `50-custom-init.sh` - Your custom script
- `99-base-end.sh` - Final setup steps

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.
Copyright (c) 2026-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
See the [LICENSE](./LICENSE) file for the full license text.

## 🔗 Links

- [Docker Hub](https://hub.docker.com/r/snowdreamtech/ubuntu)
- [GitHub Container Registry](https://github.com/snowdreamtech/ubuntu/pkgs/container/ubuntu)
- [Quay.io](https://quay.io/repository/snowdreamtech/ubuntu)
- [Source Code](https://github.com/snowdreamtech/ubuntu)
- [Issue Tracker](https://github.com/snowdreamtech/ubuntu/issues)

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/image?repos=snowdreamtech/ubuntu&type=date&legend=top-left)](https://www.star-history.com/?repos=snowdreamtech%2Fubuntu&type=date&legend=top-left)
