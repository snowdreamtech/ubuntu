# Docker Images for Ubuntu

This directory contains Docker configurations for multiple Ubuntu versions.

## Supported Versions

| Version | Codename | Base Image   | Tag Format                            |
| ------- | -------- | ------------ | ------------------------------------- |
| 22      | Jammy    | ubuntu:22.04 | 22-v22.04.0, 22-latest, jammy         |
| 24      | Noble    | ubuntu:24.04 | 24-v24.04.0, 24-latest, latest, noble |
| 25      | Questing | ubuntu:25.10 | 25-v25.10.0, 25-latest, questing      |
| 26      | Resolute | ubuntu:26.04 | 26-v26.04.0, 26-latest, resolute      |

## Directory Structure

```
docker/
├── 22/                          # Ubuntu 22.04 (Jammy)
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       └── 01-base-setup.sh     # Setup script (user, umask)
├── 24/                          # Ubuntu 24.04 (Noble)
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       └── 01-base-setup.sh     # Setup script (user, umask)
├── 25/                          # Ubuntu 25.10 (Questing)
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       └── 01-base-setup.sh     # Setup script (user, umask)
└── 26/                          # Ubuntu 26.04 (Resolute)
    ├── Dockerfile               # Multi-stage Dockerfile
    ├── docker-entrypoint.sh     # Container entrypoint script
    ├── vimrc.local              # Vim configuration
    └── entrypoint.d/            # Entrypoint scripts directory
        ├── 00-base-init.sh      # Initialization script
        └── 01-base-setup.sh     # Setup script (user, umask)
```

## Features

- **Multi-architecture support**: amd64, arm64, armhf, ppc64le, s390x (plus riscv64 on Ubuntu 24+)
- **Minimal base**: Uses official Ubuntu base images for maximum compatibility
- **User management**: Support for custom PUID/PGID
- **Configurable**: Environment variables for customization
- **Entrypoint scripts**: Modular initialization system

## Environment Variables

| Variable               | Default   | Description                                                          |
| :--------------------- | :-------- | :------------------------------------------------------------------- |
| `PUID`                 | `0`       | User ID for the running process.                                     |
| `PGID`                 | `0`       | Group ID for the running process.                                    |
| `USER`                 | `root`    | Username for the running process.                                    |
| `PASSWORDLESS_SUDO`    | `false`   | Set to `true` to grant the mapped user passwordless `sudo`.          |
| `WORKDIR`              | `/root`   | Working directory.                                                   |
| `UMASK`                | `022`     | Umask for file creation.                                             |
| `DEBUG`                | `false`   | Enable debug logging for the entrypoint.                             |
| `KEEPALIVE`            | `0`       | Set to `1` to keep the container running indefinitely.               |
| `TZ`                   | `UTC`     | Timezone setting.                                                    |
| `CAP_NET_BIND_SERVICE` | `0`       | Set to `1` to grant permission to bind to privileged ports (< 1024). |
| `LANG`                 | `C.UTF-8` | System locale and language setting.                                  |

## Usage

### Pull from Docker Hub

```bash
# Ubuntu 24 (latest)
docker pull snowdreamtech/ubuntu:latest
docker pull snowdreamtech/ubuntu:24-latest
docker pull snowdreamtech/ubuntu:24-v24.04.0
docker pull snowdreamtech/ubuntu:noble

# Ubuntu 22
docker pull snowdreamtech/ubuntu:22-latest
docker pull snowdreamtech/ubuntu:22-v22.04.0
docker pull snowdreamtech/ubuntu:jammy

# Ubuntu 25
docker pull snowdreamtech/ubuntu:25-latest
docker pull snowdreamtech/ubuntu:25-v25.10.0
docker pull snowdreamtech/ubuntu:questing

# Ubuntu 26
docker pull snowdreamtech/ubuntu:26-latest
docker pull snowdreamtech/ubuntu:26-v26.04.0
docker pull snowdreamtech/ubuntu:resolute
```

### Pull from GitHub Container Registry

```bash
# Ubuntu 24 (latest)
docker pull ghcr.io/snowdreamtech/ubuntu:latest
docker pull ghcr.io/snowdreamtech/ubuntu:24-latest
docker pull ghcr.io/snowdreamtech/ubuntu:24-v24.04.0
docker pull ghcr.io/snowdreamtech/ubuntu:noble

# Ubuntu 22
docker pull ghcr.io/snowdreamtech/ubuntu:22-latest
docker pull ghcr.io/snowdreamtech/ubuntu:22-v22.04.0
docker pull ghcr.io/snowdreamtech/ubuntu:jammy
```

### Run Container

```bash
# Basic usage
docker run -it snowdreamtech/ubuntu:latest

# With custom user
docker run -it -e PUID=1000 -e PGID=1000 -e USER=myuser snowdreamtech/ubuntu:latest

# Keep container running
docker run -d -e KEEPALIVE=1 snowdreamtech/ubuntu:latest

# With debug output
docker run -it -e DEBUG=true snowdreamtech/ubuntu:latest
```

## Building Locally

```bash
# Build specific Ubuntu variant
docker build -t ubuntu:22-local ./docker/22/
docker build -t ubuntu:24-local ./docker/24/
docker build -t ubuntu:25-local ./docker/25/
docker build -t ubuntu:26-local ./docker/26/

# Build multi-architecture image with buildx (Ubuntu 24+)
docker buildx build --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64 -t ubuntu:24-multi ./docker/24/
```

## Installed Packages

Each image includes the following packages:

- **System utilities**: `bash`, `zsh`, `lsb-release`, `procps`, `sudo`, `vim`, `nano`
- **Compression tools**: `zip`, `unzip`, `bzip2`, `xz-utils`, `gzip`
- **File utilities**: `file`
- **JSON processor**: `jq`
- **Time zone data**: `tzdata`
- **Security**: `openssl`, `gnupg`, `ca-certificates`
- **Package management**: `aptitude`
- **System monitoring**: `sysstat`
- **Network tools**: `wget`, `curl`, `git`, `dnsutils`, `netcat-traditional`, `traceroute`, `iputils-ping`, `net-tools`, `lsof`
- **Container utilities**: `libcap2-bin`, `gosu`
- **Transport**: `apt-transport-https`

## Entrypoint System

The entrypoint system executes scripts in `/usr/local/bin/entrypoint.d/` in alphabetical order:

1. **00-base-init.sh**: Initialization placeholder
2. **01-base-setup.sh**: User creation, umask configuration

## License

MIT License - see [LICENSE](../LICENSE) for details.

## Maintainer

Snowdream Tech - <https://github.com/snowdreamtech>
