# Docker Images for Ubuntu

[![CI Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/ubuntu/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/ubuntu/actions/workflows/ci.yml)
[![CD Pipeline](https://img.shields.io/github/actions/workflow/status/snowdreamtech/ubuntu/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/ubuntu/actions/workflows/cd.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/snowdreamtech/ubuntu?logo=docker)](https://hub.docker.com/r/snowdreamtech/ubuntu)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-snowdreamtech%2Fubuntu-blue?logo=github)](https://github.com/snowdreamtech/ubuntu/pkgs/container/ubuntu)
[![Multi-Architecture](https://img.shields.io/badge/Architectures-6-blue)](https://github.com/snowdreamtech/ubuntu)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
[![Release](https://img.shields.io/github/v/release/snowdreamtech/ubuntu?logo=github&sort=semver)](https://github.com/snowdreamtech/ubuntu/releases/latest)

[English](README.md) | [简体中文](README.zh_CN.md)

Enterprise-grade Docker base images for Ubuntu with comprehensive multi-architecture support and production-ready configurations.

## 🌟 Features

- **Multi-Architecture Support**: Native support for up to 6 architectures (amd64, arm64, armhf, ppc64le, s390x, riscv64)
- **Multiple Ubuntu Versions**: Ubuntu 22.04 (Jammy), 24.04 (Noble), 25.10 (Questing), and 26.04 (Resolute)
- **Minimal Base**: Built on official Ubuntu base images for optimal compatibility
- **Production Ready**: Pre-configured with essential tools and security hardening
- **Flexible User Management**: Support for custom PUID/PGID
- **Modular Entrypoint System**: Extensible initialization scripts
- **Automated Builds**: CI/CD pipeline with automated testing and publishing

## 📦 Supported Versions

| Version | Codename | Base Image | Docker Tags | Status |
|---------|----------|------------|-------------|--------|
| 26 | Resolute | ubuntu:26.04 | `26-latest`, `26-v26.04.0`, `resolute` | ✅ Active |
| 25 | Questing | ubuntu:25.10 | `25-latest`, `25-v25.10.0`, `questing` | ✅ Active |
| 24 | Noble | ubuntu:24.04 | `latest`, `24-latest`, `24-v24.04.4`, `noble` | ✅ Active |
| 22 | Jammy | ubuntu:22.04 | `22-latest`, `22-v22.04.5`, `jammy` | ✅ Active |

## 🚀 Quick Start

### Pull from Docker Hub

```bash
# Latest (Ubuntu 24.04 Noble)
docker pull snowdreamtech/ubuntu:latest

# Ubuntu 26.04 (Resolute)
docker pull snowdreamtech/ubuntu:26-latest
docker pull snowdreamtech/ubuntu:26-v26.04.0
docker pull snowdreamtech/ubuntu:resolute

# Ubuntu 25.10 (Questing)
docker pull snowdreamtech/ubuntu:25-latest
docker pull snowdreamtech/ubuntu:25-v25.10.0
docker pull snowdreamtech/ubuntu:questing

# Ubuntu 24.04 (Noble)
docker pull snowdreamtech/ubuntu:24-latest
docker pull snowdreamtech/ubuntu:24-v24.04.4
docker pull snowdreamtech/ubuntu:noble

# Ubuntu 22.04 (Jammy)
docker pull snowdreamtech/ubuntu:22-latest
docker pull snowdreamtech/ubuntu:22-v22.04.5
docker pull snowdreamtech/ubuntu:jammy
```

### Pull from GitHub Container Registry

```bash
# Latest (Ubuntu 24.04 Noble)
docker pull ghcr.io/snowdreamtech/ubuntu:latest

# Ubuntu 24.04 (Noble)
docker pull ghcr.io/snowdreamtech/ubuntu:24-latest
docker pull ghcr.io/snowdreamtech/ubuntu:24-v24.04.4
docker pull ghcr.io/snowdreamtech/ubuntu:noble

# Ubuntu 22.04 (Jammy)
docker pull ghcr.io/snowdreamtech/ubuntu:22-latest
docker pull ghcr.io/snowdreamtech/ubuntu:22-v22.04.5
docker pull ghcr.io/snowdreamtech/ubuntu:jammy
```

### Basic Usage

```bash
# Run interactive shell
docker run -it snowdreamtech/ubuntu:latest

# Run with custom user
docker run -it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  snowdreamtech/ubuntu:latest

# Keep container running in background
docker run -d \
  -e KEEPALIVE=1 \
  --name my-ubuntu \
  snowdreamtech/ubuntu:latest

# Run with debug output
docker run -it \
  -e DEBUG=true \
  snowdreamtech/ubuntu:latest
```

## 🏗️ Architecture

### Supported Platforms

| Architecture | Ubuntu 22.04 | Ubuntu 24.04+ | Notes |
|--------------|--------------|---------------|-------|
| linux/amd64 | ✅ Supported | ✅ Supported | x86-64 |
| linux/arm64 | ✅ Supported | ✅ Supported | ARM 64-bit |
| linux/armhf | ✅ Supported | ✅ Supported | ARM 32-bit v7 |
| linux/ppc64le | ✅ Supported | ✅ Supported | PowerPC 64-bit LE |
| linux/s390x | ✅ Supported | ✅ Supported | IBM System z |
| linux/riscv64 | ❌ Not Available | ✅ Supported | RISC-V 64-bit |

> **Note**: RISC-V (riscv64) support was added starting with Ubuntu 24.04.

### Directory Structure

```text
ubuntu/
├── docker/                      # Docker configurations
│   ├── 22/                      # Ubuntu 22.04 (Jammy)
│   │   ├── Dockerfile           # Multi-stage Dockerfile
│   │   ├── docker-entrypoint.sh # Container entrypoint
│   │   ├── vimrc.local          # Vim configuration
│   │   └── entrypoint.d/        # Modular entrypoint scripts
│   ├── 24/                      # Ubuntu 24.04 (Noble)
│   │   ├── Dockerfile           # Multi-stage Dockerfile
│   │   ├── docker-entrypoint.sh # Container entrypoint
│   │   ├── vimrc.local          # Vim configuration
│   │   └── entrypoint.d/        # Modular entrypoint scripts
│   ├── 25/                      # Ubuntu 25.10 (Questing)
│   │   ├── Dockerfile           # Multi-stage Dockerfile
│   │   ├── docker-entrypoint.sh # Container entrypoint
│   │   ├── vimrc.local          # Vim configuration
│   │   └── entrypoint.d/        # Modular entrypoint scripts
│   ├── 26/                      # Ubuntu 26.04 (Resolute)
│   │   ├── Dockerfile           # Multi-stage Dockerfile
│   │   ├── docker-entrypoint.sh # Container entrypoint
│   │   ├── vimrc.local          # Vim configuration
│   │   └── entrypoint.d/        # Modular entrypoint scripts
│   └── README.md                # Docker documentation
├── .github/workflows/           # CI/CD pipelines
│   ├── ci.yml                   # Continuous Integration
│   └── docker.yml               # Docker Build & Deployment
└── docs/                        # Project documentation
```

## ⚙️ Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `KEEPALIVE` | 0 | Keep container running (1=yes, 0=no) |
| `CAP_NET_BIND_SERVICE` | 0 | Enable binding to privileged ports (<1024) |
| `LANG` | C.UTF-8 | Locale setting for UTF-8 support |
| `UMASK` | 022 | File creation mask |
| `DEBUG` | false | Enable debug output in entrypoint scripts |
| `PASSWORDLESS_SUDO` | false | Enable passwordless sudo for custom user |
| `PGID` | 0 | Group ID for custom user |
| `PUID` | 0 | User ID for custom user |
| `USER` | root | Username (creates user if not root) |
| `WORKDIR` | /root | Working directory |
| `TZ` | - | Timezone (e.g., Asia/Shanghai) |

### Installed Packages

Each image includes essential tools for development and operations:

#### System Utilities

- bash, zsh, nano, rsync, lsb-release, procps, sudo, vim

#### Compression Tools

- zip, unzip, bzip2, xz-utils, gzip

#### File & Data Tools

- file, jq

#### Time & Locale

- tzdata

#### Security & Certificates

- openssl, gnupg, ca-certificates

#### Package Management

- aptitude

#### System Monitoring

- sysstat

#### Network Tools

- wget, curl, git, dnsutils, netcat-traditional, traceroute, iputils-ping, net-tools, lsof

#### Container Utilities

- libcap2-bin, gosu

#### Transport

- apt-transport-https

## 🔧 Building Locally

### Prerequisites

- Docker 20.10+ or Docker Desktop
- Docker Buildx (for multi-architecture builds)

### Build Commands

```bash
# Build Ubuntu 22.04
docker build -t ubuntu:22-local docker/22/

# Build Ubuntu 24.04
docker build -t ubuntu:24-local docker/24/

# Build Ubuntu 25.10
docker build -t ubuntu:25-local docker/25/

# Build Ubuntu 26.04
docker build -t ubuntu:26-local docker/26/

# Build with specific platform
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ubuntu:24-local \
  docker/24/

# Build all platforms for Ubuntu 24.04+ (requires buildx)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64 \
  -t ubuntu:24-multi \
  docker/24/

# Build all platforms for Ubuntu 22.04 (no riscv64)
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x \
  -t ubuntu:22-multi \
  docker/22/
```

## 📚 Documentation

- [Docker Configuration Guide](docker/README.md) - Detailed docker setup and usage
- [Contributing Guide](CONTRIBUTING.md) - How to contribute to this project
- [Changelog](CHANGELOG.md) - Version history and release notes
- [Security Policy](SECURITY.md) - Security reporting and policies

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on:

- Code of Conduct
- Development workflow
- Commit message conventions
- Pull request process

## 🔒 Security

Security is a top priority. If you discover a security vulnerability, please follow our [Security Policy](SECURITY.md) for responsible disclosure.

## 📄 License

This project is licensed under the **MIT License**.
Copyright (c) 2026-present [SnowdreamTech Inc.](https://github.com/snowdreamtech)
See the [LICENSE](./LICENSE) file for the full license text.

## 🙏 Acknowledgments

- Based on official [Ubuntu Docker images](https://hub.docker.com/_/ubuntu)
- Inspired by best practices from the Docker community
- Built with [GitHub Actions](https://github.com/features/actions)

## 📞 Support

- 📧 Email: <sn0wdr1am@qq.com>
- 🐛 Issues: [GitHub Issues](https://github.com/snowdreamtech/ubuntu/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/snowdreamtech/ubuntu/discussions)

## Star History

[![Star History Chart](https://api.star-history.com/image?repos=snowdreamtech/ubuntu&type=date&legend=top-left)](https://www.star-history.com/?repos=snowdreamtech%2Fubuntu&type=date&legend=top-left)
