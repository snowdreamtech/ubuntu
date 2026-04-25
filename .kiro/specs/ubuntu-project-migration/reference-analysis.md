# Reference Project Structure Analysis

## Overview

This document analyzes the debian reference project structure located at `/Users/snowdreamtech/Workspace/snowdreamtech/debian` (main branch). The patterns documented here serve as the standard template for the Ubuntu project migration.

**Note**: This analysis is based on the design document specifications, as the debian project is outside the workspace and cannot be accessed directly.

## 1. Standard Dockerfile Patterns

### Base Structure

The debian reference project uses the following Dockerfile structure:

```dockerfile
# 1. Base Image Declaration
FROM debian:{version}

# 2. OCI Labels (Metadata)
LABEL org.opencontainers.image.authors="Snowdream Tech"
LABEL org.opencontainers.image.title="Debian Base Image"
LABEL org.opencontainers.image.description="Docker Images for Debian"
LABEL org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/debian"
LABEL org.opencontainers.image.base.name="debian:{version}"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/snowdreamtech/debian"
LABEL org.opencontainers.image.vendor="Snowdream Tech"
LABEL org.opencontainers.image.version="{version}"
LABEL org.opencontainers.image.url="https://github.com/snowdreamtech/debian"

# 3. Build Arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG KEEPALIVE=0
ARG CAP_NET_BIND_SERVICE=0

# 4. Environment Variables
ENV LANG=C.UTF-8
ENV UMASK=022
ENV DEBUG=false
ENV PGID=0
ENV PUID=0
ENV USER=root
ENV WORKDIR=/root

# 5. Package Installation
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        vim \
        jq \
        gosu \
        ca-certificates \
        net-tools \
        iputils-ping \
        dnsutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 6. Entrypoint Setup
COPY docker-entrypoint.sh /usr/local/bin/
COPY entrypoint.d/ /usr/local/bin/entrypoint.d/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.d/*.sh

# 7. Entrypoint Configuration
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
```

### Key Implementation Patterns

1. **Official Base Images**: Uses official Debian images from Docker Hub
2. **OCI Compliance**: Comprehensive metadata labels following OpenContainers specification
3. **Build Arguments**: Configurable build-time parameters
4. **Environment Variables**: Runtime configuration with sensible defaults
5. **Minimal Package Set**: Only essential tools installed
6. **Layer Optimization**: Combined RUN commands to reduce image size
7. **Cleanup**: Removes apt cache and lists after installation
8. **Executable Permissions**: Explicitly sets execute permissions for scripts

## 2. docker-entrypoint.sh Patterns

### Script Structure

```bash
#!/bin/sh
set -e

# Enable debug mode if DEBUG=true
if [ "${DEBUG}" = "true" ]; then
    set -x
fi

# Execute all scripts in entrypoint.d/
if [ -d /usr/local/bin/entrypoint.d ]; then
    for script in /usr/local/bin/entrypoint.d/*; do
        if [ -x "$script" ]; then
            if [ "${DEBUG}" = "true" ]; then
                echo "Executing: $script"
            fi
            "$script" "$@"
        fi
    done
fi

# Execute the main command
exec "$@"
```

### Key Patterns in docker-entrypoint.sh

1. **POSIX Compliance**: Uses `#!/bin/sh` for maximum compatibility
2. **Fail-Fast**: Uses `set -e` to exit on errors
3. **Debug Support**: Conditional debug logging with `set -x`
4. **Modular Execution**: Iterates through entrypoint.d/ scripts
5. **Lexicographic Order**: Scripts execute in alphabetical order
6. **Executable Check**: Only runs scripts with execute permission
7. **Argument Passing**: Forwards all arguments to each script
8. **Command Execution**: Uses `exec` to replace shell process with main command

## 3. entrypoint.d/ Script Patterns

### Directory Structure

```
entrypoint.d/
├── 00-base-init.sh      # Early initialization
├── 01-base-setup.sh     # Configuration setup
└── 99-base-end.sh       # Final setup steps
```

### Naming Convention

- **Prefix Numbers**: Two-digit prefix (00-99) controls execution order
- **Descriptive Names**: Clear indication of script purpose
- **Extension**: Always `.sh` for shell scripts

### Script Template

```bash
#!/bin/sh
set -e

# Enable debug mode if DEBUG=true
if [ "${DEBUG}" = "true" ]; then
    set -x
    echo "Running: $(basename "$0")"
fi

# Script-specific logic here
# ...

# Exit successfully
exit 0
```

### Common Script Functions

#### 00-base-init.sh

- System initialization
- Environment validation
- Directory creation

#### 01-base-setup.sh

- User creation (if PUID/PGID specified)
- Permission configuration
- Working directory setup

#### 99-base-end.sh

- Final configuration
- Service startup preparation
- Cleanup tasks

### Key Patterns in entrypoint.d Scripts

1. **POSIX Compliance**: Uses `#!/bin/sh`
2. **Fail-Fast**: Uses `set -e`
3. **Debug Support**: Conditional debug logging
4. **Idempotency**: Scripts can be run multiple times safely
5. **Error Handling**: Explicit error checking and reporting
6. **Modularity**: Each script has a single, clear purpose
7. **Exit Codes**: Explicit exit 0 on success

## 4. GitHub Workflow Structure (docker.yml)

### Workflow Overview

```yaml
name: Docker

on:
  push:
    branches:
      - main
      - dev
    tags:
      - '*-v*'
  schedule:
    - cron: '0 17 * * *'
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to build'
        required: false
        type: choice
        options:
          - all
          - '11'
          - '12'

jobs:
  buildx:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        include:
          - version: "11"
            codename: "bullseye"
            is_latest: false
          - version: "12"
            codename: "bookworm"
            is_latest: true

    steps:
      # 1. Security hardening
      - name: Harden Runner
        uses: step-security/harden-runner@v2
        with:
          egress-policy: audit

      # 2. Checkout code
      - name: Checkout
        uses: actions/checkout@v4

      # 3. Set up QEMU for multi-platform
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      # 4. Set up Docker Buildx
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # 5. Registry logins
      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # 6. Build and push
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: docker/${{ matrix.version }}
          platforms: linux/amd64,linux/arm64,linux/armhf
          push: true
          tags: |
            snowdreamtech/debian:${{ matrix.version }}-latest
            snowdreamtech/debian:${{ matrix.codename }}
            snowdreamtech/debian:${{ matrix.codename }}-latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

      # 7. Security scanning
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: snowdreamtech/debian:${{ matrix.version }}-latest
          format: 'sarif'
          output: 'trivy-results.sarif'

      # 8. Upload scan results
      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: 'trivy-results.sarif'
```

### Key Patterns in GitHub Workflow

1. **Multi-Trigger**: Push, schedule, manual dispatch
2. **Matrix Strategy**: Build multiple versions in parallel
3. **Fail-Safe**: `fail-fast: false` allows other builds to continue
4. **Security First**: Harden Runner, Trivy scanning, SARIF upload
5. **Multi-Platform**: QEMU + Buildx for cross-platform builds
6. **Multi-Registry**: Support for DockerHub, GHCR, Quay.io
7. **Build Cache**: GitHub Actions cache for faster builds
8. **Comprehensive Tags**: Version, codename, latest, nightly, date tags
9. **Smoke Tests**: Verify images in each registry
10. **Build Summary**: Detailed output in GitHub Actions UI

## 5. Version Codename Tag Patterns

### Tag Structure

The debian project uses the following tag patterns:

#### Branch-Based Tags

- `{version}-{branch}`: e.g., `11-main`, `12-dev`
- Applied on push to main/dev branches

#### Latest Tags

- `{version}-latest`: e.g., `11-latest`, `12-latest`
- Always points to the most recent build for that version
- `latest`: Global latest tag (only for `is_latest: true` version)

#### Semantic Version Tags

- `{semantic_version}`: e.g., `11.0.0`, `12.0.0`
- Applied when pushing version tags
- `{version}-v{semantic_version}`: e.g., `11-v11.0.0`, `12-v12.0.0`

#### Codename Tags

- `{codename}`: e.g., `bullseye`, `bookworm`
- Debian release codenames
- `{codename}-latest`: e.g., `bullseye-latest`, `bookworm-latest`

#### Nightly Tags

- `{version}-nightly`: e.g., `11-nightly`, `12-nightly`
- Applied on scheduled builds

#### Date Tags

- `{version}-{YYYYMMDD}`: e.g., `11-20250115`, `12-20250115`
- Applied on scheduled builds

### Tag Application Logic

```yaml
# Conditional tag generation based on trigger
tags: |
  # Branch tags (on push to main/dev)
  ${{ github.ref_name == 'main' && format('snowdreamtech/debian:{0}-main', matrix.version) || '' }}
  ${{ github.ref_name == 'dev' && format('snowdreamtech/debian:{0}-dev', matrix.version) || '' }}

  # Latest tags (always)
  snowdreamtech/debian:${{ matrix.version }}-latest

  # Global latest (only for is_latest version)
  ${{ matrix.is_latest && 'snowdreamtech/debian:latest' || '' }}

  # Semantic version tags (on tag push)
  ${{ startsWith(github.ref, 'refs/tags/') && format('snowdreamtech/debian:{0}', github.ref_name) || '' }}

  # Codename tags (always)
  snowdreamtech/debian:${{ matrix.codename }}
  snowdreamtech/debian:${{ matrix.codename }}-latest

  # Nightly tags (on schedule)
  ${{ github.event_name == 'schedule' && format('snowdreamtech/debian:{0}-nightly', matrix.version) || '' }}

  # Date tags (on schedule)
  ${{ github.event_name == 'schedule' && format('snowdreamtech/debian:{0}-{1}', matrix.version, env.DATE) || '' }}
```

### Ubuntu Adaptation

For Ubuntu, the codename mapping is:

| Version | Codename | Latest |
|---------|----------|--------|
| 22.04   | jammy    | No     |
| 24.04   | noble    | Yes    |
| 25.10   | questing | No     |
| 26.04   | resolute | No     |

## 6. Architecture Support Patterns

### Platform Configuration

The debian project configures architecture support per version:

```yaml
# Debian 11 (Bullseye)
platforms: linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x

# Debian 12 (Bookworm)
platforms: linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64
```

### Key Patterns in Architecture Support

1. **Version-Specific**: Different versions support different architectures
2. **Official Support**: Based on official Debian/Ubuntu Docker Hub specifications
3. **Comma-Separated**: Platform list uses comma separation
4. **Prefix**: All platforms use `linux/` prefix
5. **QEMU Emulation**: Uses QEMU for cross-platform builds
6. **Buildx**: Leverages Docker Buildx for multi-platform support

### Ubuntu Architecture Support

Based on official Ubuntu Docker Hub specifications:

```yaml
# Ubuntu 22.04 (Jammy)
platforms: linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x

# Ubuntu 24.04 (Noble)
platforms: linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64

# Ubuntu 25.10 (Questing)
platforms: linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64

# Ubuntu 26.04 (Resolute)
platforms: linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64
```

## 7. Security and Supply Chain Patterns

### Security Features

1. **Harden Runner**: Egress audit for GitHub Actions
2. **Trivy Scanning**: Vulnerability detection
3. **SARIF Upload**: Integration with GitHub Security
4. **Cosign Signing**: Keyless OIDC image signing
5. **SBOM Generation**: CycloneDX format
6. **Provenance Attestation**: SLSA compliance

### Implementation Pattern

```yaml
# Trivy scanning
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: ${{ env.IMAGE_TAG }}
    format: 'sarif'
    output: 'trivy-results.sarif'
    severity: 'CRITICAL,HIGH'

# SARIF upload
- name: Upload Trivy results to GitHub Security
  uses: github/codeql-action/upload-sarif@v3
  with:
    sarif_file: 'trivy-results.sarif'

# Cosign signing
- name: Sign image with Cosign
  run: |
    cosign sign --yes ${{ env.IMAGE_TAG }}
```

## 8. Build Optimization Patterns

### Cache Strategy

```yaml
cache-from: type=gha
cache-to: type=gha,mode=max
```

### Disk Space Management

```yaml
- name: Free Disk Space
  uses: jlumbroso/free-disk-space@main
  with:
    tool-cache: false
    android: true
    dotnet: true
    haskell: true
    large-packages: true
    docker-images: false
```

### Build Context

- Each version has its own build context: `docker/{version}/`
- Minimizes context size for faster uploads
- Isolates version-specific files

## Summary

The debian reference project provides a comprehensive, production-ready template for Docker image building with:

1. **Structured Dockerfiles**: Clear, maintainable, OCI-compliant
2. **Modular Entrypoints**: Flexible, extensible initialization
3. **Automated Workflows**: Multi-platform, multi-registry, secure
4. **Comprehensive Tagging**: Multiple tag strategies for different use cases
5. **Security First**: Scanning, signing, attestation
6. **Performance Optimized**: Caching, parallel builds, minimal layers

These patterns should be adapted for Ubuntu while respecting system-specific differences (package names, commands, architecture support).
