# Design Document

## Overview

This document defines the technical design for migrating Ubuntu Docker image project code from the legacy ubuntu0 repository to the current ubuntu repository. The migration follows a structured, atomic approach using the debian project as a reference standard, ensuring consistency in Docker image structure, build workflows, and cross-platform support.

### Design Goals

1. **Structural Consistency**: Align project structure with the debian reference project while accommodating Ubuntu-specific requirements
2. **Version Isolation**: Maintain separate, version-specific configurations for Ubuntu 22.04, 24.04, 25.10, and 26.04
3. **Atomic Migration**: Execute changes as independent, reversible commits following Conventional Commits specification
4. **Cross-Platform Compatibility**: Ensure all scripts and configurations work across Linux, macOS, and Windows
5. **Architecture Support**: Configure correct platform architectures for each Ubuntu version based on official Docker Hub specifications
6. **Automation**: Leverage GitHub Actions for multi-platform Docker image builds with comprehensive testing and security scanning

### Key Constraints

- Must use the Current_Project (ubuntu) dev branch as the base
- Must NOT access /Users/snowdream/Workspace/snowdreamtech/debian directly (outside workspace)
- Must follow Conventional Commits specification for all commit messages
- Must auto-commit changes but NOT auto-push to remote
- Must run lint and format auto-fixes before each commit
- Must use relative paths only (no absolute paths starting with /Users/, C:\, or ~)
- Must maintain idempotency in all scripts and configurations

## Architecture

### High-Level Architecture

The migration follows a layered architecture pattern:

\`\`\`
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Actions Layer                      │
│  (CI/CD Orchestration, Multi-Platform Builds, Security)     │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────┴──────────────────────────────────────┐
│                  Version Management Layer                    │
│     (docker/22, docker/24, docker/25, docker/26)            │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────┴──────────────────────────────────────┐
│                   Container Runtime Layer                    │
│  (Dockerfile, Entrypoint, Scripts, Configuration)           │
└─────────────────────────────────────────────────────────────┘
\`\`\`

### Directory Structure

\`\`\`
ubuntu/
├── .github/
│   └── workflows/
│       └── docker.yml              # Multi-platform build workflow
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
├── scripts/                        # Build and maintenance scripts
└── .kiro/specs/ubuntu-project-migration/  # This specification
\`\`\`

### Migration Workflow

\`\`\`mermaid
graph TD
    A[Start Migration] --> B[Verify dev Branch]
    B --> C[Analyze Reference Project]
    C --> D[Create Version Folders]
    D --> E[Migrate Dockerfiles]
    E --> F[Migrate Entrypoint Scripts]
    F --> G[Migrate GitHub Workflow]
    G --> H[Configure Architecture Support]
    H --> I[Add Version Codename Tags]
    I --> J[Run Lint & Format]
    J --> K{Lint Pass?}
    K -->|No| L[Fix Issues]
    L --> J
    K -->|Yes| M[Commit Changes]
    M --> N{More Changes?}
    N -->|Yes| D
    N -->|No| O[Migration Complete]
\`\`\`

## Components and Interfaces

### 1. Version Folder Component

**Purpose**: Isolate version-specific Docker configurations

**Structure**:

- Each version folder (22, 24, 25, 26) contains:
  - `Dockerfile`: Base image definition and package installation
  - `docker-entrypoint.sh`: Container initialization script
  - `entrypoint.d/`: Modular initialization scripts

**Interface**:

- Input: Ubuntu version number (22, 24, 25, 26)
- Output: Complete Docker build context for that version

**Design Decisions**:

- Use numeric folder names (22, 24, 25, 26) instead of full versions (22.04, 24.04) for brevity
- Map folders to full versions in GitHub workflow configuration
- Maintain identical structure across all version folders for consistency

### 2. Dockerfile Component

**Purpose**: Define Ubuntu base image with essential tooling

**Key Sections**:

1. **Base Image**: Official Ubuntu image from Docker Hub
2. **OCI Labels**: Metadata following OpenContainers specification
3. **Environment Variables**: Runtime configuration (LANG, DEBIAN_FRONTEND, DEBUG, PUID, PGID, etc.)
4. **Package Installation**: Essential tools (curl, git, vim, jq, gosu, network utilities)
5. **User Management**: Support for non-root user creation with custom PUID/PGID
6. **Entrypoint Setup**: Copy and configure entrypoint scripts

**FROM Directive Mapping**:

- Version 22 → `FROM ubuntu:22.04`
- Version 24 → `FROM ubuntu:24.04`
- Version 25 → `FROM ubuntu:25.10`
- Version 26 → `FROM ubuntu:26.04`

**Design Decisions**:

- Use multi-stage builds where beneficial for size optimization
- Pin base image to specific Ubuntu version (not `latest`)
- Install minimal set of packages required for base functionality
- Support both root and non-root execution modes
- Enable debug mode via DEBUG environment variable

### 3. Entrypoint Component

**Purpose**: Provide flexible, modular container initialization

**Architecture**:
\`\`\`
docker-entrypoint.sh (orchestrator)
    ↓
entrypoint.d/ (modular scripts)
    ├── 00-base-init.sh      # Early initialization
    ├── 01-base-setup.sh     # Configuration setup
    └── 99-base-end.sh       # Final setup steps
\`\`\`

**Execution Flow**:

1. `docker-entrypoint.sh` iterates through `/usr/local/bin/entrypoint.d/*`
2. Executes each script in lexicographic order if executable
3. Passes all arguments to each script
4. Logs execution when DEBUG=true

**Interface**:

- Input: Environment variables (DEBUG, PUID, PGID, USER, WORKDIR, etc.)
- Output: Configured container environment
- Side Effects: User creation, permission changes, directory setup

**Design Decisions**:

- Use POSIX-compliant shell (`#!/bin/sh`) for maximum compatibility
- Implement fail-fast behavior (`set -e`)
- Support conditional debug logging
- Allow script extension by adding files to `entrypoint.d/`

### 4. GitHub Actions Workflow Component

**Purpose**: Automate multi-platform Docker image builds and delivery

**Key Jobs**:

1. **buildx**: Build and push multi-platform images

**Workflow Triggers**:

- Push to `main` or `dev` branches
- Push of version tags (e.g., `22-v22.04.0`, `24-v24.04.0`)
- Daily schedule (cron: `0 17 * * *`)
- Manual workflow dispatch with version selection

**Matrix Strategy**:
\`\`\`yaml
matrix:
  include:
    - version: "22"
      codename: "jammy"
      is_latest: false
    - version: "24"
      codename: "noble"
      is_latest: true
    - version: "25"
      codename: "questing"
      is_latest: false
    - version: "26"
      codename: "resolute"
      is_latest: false
\`\`\`

**Architecture Support by Version**:

- Ubuntu 22.04: `linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x`
- Ubuntu 24.04: `linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64`
- Ubuntu 25.10: `linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64`
- Ubuntu 26.04: `linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64`

**Tag Strategy**:

- Version-prefixed branch tags: `22-dev`, `24-main`
- Version-latest tags: `22-latest`, `24-latest`
- Global latest tag: `latest` (only for `is_latest` version)
- Semantic version tags: `22.04.0`, `24.04.0`
- Version-prefixed semantic tags: `22-v22.04.0`, `24-v24.04.0`
- Codename tags: `jammy`, `noble`, `questing`, `resolute`
- Codename-latest tags: `jammy-latest`, `noble-latest`
- Nightly tags: `22-nightly`, `24-nightly`
- Date tags: `22-20250115`, `24-20250115`

**Security Features**:

- Harden Runner for egress audit
- Trivy vulnerability scanning
- SBOM generation (CycloneDX)
- Provenance attestation (SLSA)
- Cosign image signing (keyless OIDC)

**Design Decisions**:

- Use Docker Buildx for multi-platform builds
- Implement GitHub Actions cache for build acceleration
- Support multiple container registries (DockerHub, GHCR, Quay.io)
- Include comprehensive smoke tests for each registry
- Generate detailed build summaries in GitHub Actions UI

### 5. Version Management Component

**Purpose**: Map version folders to full version numbers and codenames

**Mapping Table**:

| Folder | Version | Codename | Latest | Architectures |
|--------|---------|----------|--------|---------------|
| 22     | 22.04   | jammy    | No     | 5 platforms   |
| 24     | 24.04   | noble    | Yes    | 6 platforms   |
| 25     | 25.10   | questing | No     | 6 platforms   |
| 26     | 26.04   | resolute | No     | 6 platforms   |

**Interface**:

- Input: Version folder name (22, 24, 25, 26)
- Output: Full version number, codename, architecture list, latest flag

**Design Decisions**:

- Centralize version mapping in GitHub workflow matrix
- Use `is_latest` flag to control global `latest` tag assignment
- Support version-specific tag filtering for targeted builds

## Data Models

### Docker Image Metadata

\`\`\`yaml
OCI Labels:
  org.opencontainers.image.authors: "Snowdream Tech"
  org.opencontainers.image.title: "Ubuntu Base Image"
  org.opencontainers.image.description: "Docker Images for Ubuntu"
  org.opencontainers.image.documentation: "<https://hub.docker.com/r/snowdreamtech/ubuntu>"
  org.opencontainers.image.base.name: "ubuntu:{version}"
  org.opencontainers.image.licenses: "MIT"
  org.opencontainers.image.source: "<https://github.com/snowdreamtech/ubuntu>"
  org.opencontainers.image.vendor: "Snowdream Tech"
  org.opencontainers.image.version: "{version}"
  org.opencontainers.image.url: "<https://github.com/snowdreamtech/ubuntu>"
  org.opencontainers.image.created: "{build_timestamp}"
  org.opencontainers.image.revision: "{git_commit_sha}"
\`\`\`

### Environment Variables

\`\`\`yaml
Build-time Arguments:
  DEBIAN_FRONTEND: "noninteractive"  # Suppress interactive prompts
  KEEPALIVE: "0"                     # Keep container running (0=no, 1=yes)
  CAP_NET_BIND_SERVICE: "0"          # Allow binding to privileged ports
  LANG: "C.UTF-8"                    # Default locale
  UMASK: "022"                       # Default file creation mask
  DEBUG: "false"                     # Enable debug logging
  PGID: "0"                          # Primary group ID
  PUID: "0"                          # User ID
  USER: "root"                       # Username
  WORKDIR: "/root"                   # Working directory

Runtime Environment:
  All build-time arguments are promoted to environment variables
  Additional variables can be set at container runtime
\`\`\`

### Version Configuration

\`\`\`yaml
Version:
  folder: "22" | "24" | "25" | "26"
  version: "22.04" | "24.04" | "25.10" | "26.04"
  codename: "jammy" | "noble" | "questing" | "resolute"
  is_latest: boolean
  architectures:
    - "linux/amd64"
    - "linux/arm64"
    - "linux/armhf"
    - "linux/ppc64le"
    - "linux/s390x"
    - "linux/riscv64"  # Only for versions 24, 25, 26
\`\`\`

### Commit Message Structure

\`\`\`yaml
Format: "<type>(<scope>): <description>"

Type:

  - "feat"      # New feature
  - "fix"       # Bug fix
  - "ci"        # CI/CD changes
  - "refactor"  # Code restructuring
  - "docs"      # Documentation
  - "chore"     # Maintenance

Scope:

  - "docker"           # Dockerfile changes
  - "workflow"         # GitHub Actions workflow
  - "github-actions"   # GitHub Actions workflow
  - "scripts"          # Shell scripts
  - "entrypoint"       # Entrypoint scripts

Description:

  - Max 120 characters
  - Imperative mood
  - No period at end
  - English only
\`\`\`

## Error Handling

### Build Failures

**Scenario**: Docker build fails for a specific platform

**Handling**:

1. GitHub Actions workflow continues with other platforms (fail-fast: false)
2. Failed platform is logged in build summary
3. Workflow marks the job as failed
4. No images are pushed if any platform fails

**Recovery**:

- Review build logs for specific platform
- Fix platform-specific issues in Dockerfile
- Re-trigger workflow for affected version

### Lint Failures

**Scenario**: Pre-commit hooks or CI lint checks fail

**Handling**:

1. Auto-fix is attempted for fixable issues (formatting, trailing whitespace)
2. Non-fixable issues block the commit
3. Error messages indicate specific files and line numbers

**Recovery**:

- Review lint error messages
- Manually fix non-fixable issues
- Re-run lint checks
- Commit only after all checks pass

### Registry Authentication Failures

**Scenario**: Login to DockerHub, GHCR, or Quay.io fails

**Handling**:

1. Each registry login is attempted independently (continue-on-error: true)
2. Workflow checks if at least one registry login succeeded
3. If all logins fail, workflow exits with error
4. If at least one succeeds, build continues

**Recovery**:

- Verify registry credentials in GitHub Secrets
- Check registry service status
- Re-trigger workflow after fixing credentials

### Version Tag Mismatch

**Scenario**: Tag pushed doesn't match any version pattern

**Handling**:

1. Version filter step checks if tag matches version pattern
2. If no match, job is skipped for that version
3. Build summary indicates skip reason

**Recovery**:

- Verify tag format follows pattern: `{version}-v{semantic_version}`
- Example: `22-v22.04.0`, `24-v24.04.1`
- Re-push with correct tag format

### Vulnerability Scan Failures

**Scenario**: Trivy scan detects critical vulnerabilities

**Handling**:

1. Trivy scan runs with continue-on-error: true
2. Vulnerabilities are logged in SARIF format
3. SARIF is uploaded to GitHub Security tab
4. Build continues but warnings are displayed

**Recovery**:

- Review vulnerability report in GitHub Security
- Update base image or packages to patched versions
- Re-build and re-scan

### Disk Space Exhaustion

**Scenario**: GitHub Actions runner runs out of disk space

**Handling**:

1. Workflow includes disk space optimization step
2. Removes Android, .NET, Haskell, and large packages
3. Preserves Docker images and tool cache

**Recovery**:

- If still insufficient, reduce number of concurrent builds
- Use smaller base images
- Clean up intermediate layers more aggressively

## Testing Strategy

### Testing Approach for Infrastructure as Code

This project is primarily Infrastructure as Code (IaC) focused on Docker image building and GitHub Actions workflows. **Property-based testing is NOT appropriate for this type of project**. Instead, we use a combination of:

1. **Snapshot Tests**: Verify generated Docker images match expected configurations
2. **Integration Tests**: Test actual Docker image builds and container execution
3. **Smoke Tests**: Verify basic functionality of built images
4. **Policy Checks**: Validate Dockerfile best practices and security policies
5. **Example-Based Unit Tests**: Test specific scenarios with concrete examples

### 1. Dockerfile Validation

**Tool**: hadolint

**Scope**: All Dockerfiles in `docker/*/Dockerfile`

**Checks**:

- Best practices compliance (DL3000-DL4000 rules)
- Security issues (running as root, using latest tags)
- Maintainability issues (multiple RUN commands, missing labels)

**Execution**:

- Pre-commit hook: Staged Dockerfiles only
- CI: All Dockerfiles in repository

**Example**:
\`\`\`bash
hadolint docker/22/Dockerfile
hadolint docker/24/Dockerfile
hadolint docker/25/Dockerfile
hadolint docker/26/Dockerfile
\`\`\`

### 2. Shell Script Validation

**Tool**: ShellCheck

**Scope**: All `.sh` scripts

**Checks**:

- POSIX compliance
- Common scripting errors (unquoted variables, missing error handling)
- Security issues (command injection, path traversal)

**Execution**:

- Pre-commit hook: Staged scripts only
- CI: All scripts in repository

**Example**:
\`\`\`bash
shellcheck docker/*/docker-entrypoint.sh
shellcheck docker/*/entrypoint.d/*.sh
\`\`\`

### 3. Workflow Validation

**Tool**: yamllint, actionlint

**Scope**: `.github/workflows/*.yml`

**Checks**:

- YAML syntax and formatting
- GitHub Actions best practices
- Deprecated action versions
- Security issues (hardcoded secrets, missing permissions)

**Execution**:

- Pre-commit hook: Staged workflows only
- CI: All workflows in repository

**Example**:
\`\`\`bash
yamllint .github/workflows/docker.yml
actionlint .github/workflows/docker.yml
\`\`\`

### 4. Integration Tests

**Scope**: Docker image build and execution

**Test Cases**:

#### Test 1: Image Build Success

```bash
# For each version (22, 24, 25, 26)
docker build -t ubuntu-test:${version} docker/${version}/
```

**Expected**: Build completes without errors

#### Test 2: Container Startup

\`\`\`bash
docker run --rm ubuntu-test:${version} echo "Hello"
\`\`\`

**Expected**: Container starts, executes command, exits cleanly

#### Test 3: Entrypoint Execution

\`\`\`bash
docker run --rm -e DEBUG=true ubuntu-test:${version}
\`\`\`

**Expected**: Entrypoint scripts execute in order, debug logs visible

#### Test 4: Non-Root User Creation

\`\`\`bash
docker run --rm -e PUID=1000 -e PGID=1000 -e USER=testuser ubuntu-test:${version} id
\`\`\`

**Expected**: User created with correct UID/GID

#### Test 5: Essential Tools Available

\`\`\`bash
docker run --rm ubuntu-test:${version} sh -c '
  command -v curl && \
  command -v git && \
  command -v jq && \
  command -v vim
'
\`\`\`

**Expected**: All essential tools are installed and accessible

### 5. Smoke Tests (CI)

**Scope**: Published Docker images

**Test Cases**:

##### Test 1: Multi-Registry Availability

```bash
# Test DockerHub
docker pull snowdreamtech/ubuntu:${version}-latest

# Test GHCR
docker pull ghcr.io/snowdreamtech/ubuntu:${version}-latest

# Test Quay.io
docker pull quay.io/snowdreamtech/ubuntu:${version}-latest
```

**Expected**: Images are pullable from all registries

##### Test 2: Comprehensive Functionality

\`\`\`bash
docker run --rm \
  -e DEBUG=false \
  -e TZ=Asia/Shanghai \
  -e PUID=1000 \
  -e PGID=1000 \
  ${image_tag} \
  sh -c '
    echo "✓ Entrypoint execution: OK" && \
    printf "✓ Timezone: " && date "+%Z %z" && \
    printf "✓ User context: " && id -un && \
    printf "✓ Core tools: " && \
    command -v apt && command -v bash && \
    command -v curl && command -v git && \
    echo "apt, bash, curl, git" && \
    printf "✓ Package manager: " && \
    apt list busybox 2>/dev/null | grep -q busybox && echo "functional" && \
    echo "✓ All checks passed"
  '
\`\`\`

**Expected**: All checks pass, correct timezone, user context, tools available

##### Test 3: Multi-Platform Manifest

\`\`\`bash
docker buildx imagetools inspect ${image_tag}
\`\`\`

**Expected**: Manifest shows all expected platforms for the version

### 6. Security Scanning

**Tool**: Trivy

**Scope**: Built Docker images

**Checks**:

- OS package vulnerabilities
- Application dependency vulnerabilities
- Misconfigurations
- Secrets in image layers

**Severity Levels**:

- CRITICAL: Block deployment
- HIGH: Warning, review required
- MEDIUM: Informational
- LOW: Informational

**Execution**:

- CI: After successful build
- Results uploaded to GitHub Security tab (SARIF format)

**Example**:
\`\`\`bash
trivy image --exit-code 1 --severity HIGH,CRITICAL \
  --ignore-unfixed \
  snowdreamtech/ubuntu:${version}-latest
\`\`\`

### 7. Commit Message Validation

**Tool**: commitlint

**Scope**: All commit messages

**Checks**:

- Conventional Commits format
- Header length ≤ 120 characters
- Valid type and scope
- Imperative mood
- No period at end
- English only

**Execution**:

- Pre-commit hook: Current commit message
- CI: All commits in PR

**Example**:
\`\`\`bash
echo "feat(docker): add Ubuntu 22.04 support" | commitlint
\`\`\`

### 8. Test Execution Strategy

**Local Development**:

1. Pre-commit hooks run automatically on `git commit`
2. Developers can run `make lint` for full repository scan
3. Developers can run `make test` for integration tests

**Continuous Integration**:

1. Lint checks run on every push and PR
2. Integration tests run on every push to main/dev
3. Full build and smoke tests run on tag push
4. Security scans run on every successful build
5. Nightly builds run full test suite

**Test Data**:

- Use official Ubuntu base images from Docker Hub
- Test with multiple timezone values (UTC, Asia/Shanghai, America/New_York)
- Test with various PUID/PGID combinations (0, 1000, 65534)
- Test with different USER values (root, ubuntu, testuser)

### 9. Quality Gates

**Pre-Commit**:

- All linters must pass (hadolint, shellcheck, yamllint)
- All formatters must be applied (shfmt, prettier)
- Commit message must pass commitlint

**CI**:

- All lint checks must pass
- All integration tests must pass
- Docker build must succeed for all platforms
- At least one registry login must succeed
- Smoke tests must pass for all available registries

**Deployment**:

- Trivy scan must not find CRITICAL vulnerabilities
- Multi-platform manifest must be complete
- Image must be signed with Cosign
- SBOM must be generated

### 10. Test Maintenance

**Regular Updates**:

- Update hadolint rules quarterly
- Update ShellCheck version monthly
- Update Trivy database daily (automatic)
- Review and update test cases when adding new features

**Test Coverage Goals**:

- 100% of Dockerfiles validated by hadolint
- 100% of shell scripts validated by ShellCheck
- 100% of workflows validated by yamllint/actionlint
- 100% of versions tested in integration tests
- 100% of published images smoke tested

## Implementation Notes

### Migration Execution Order

1. **Phase 1: Foundation**
   - Verify dev branch checkout
   - Create docker/ directory structure
   - Create version folders (22, 24, 25, 26)

2. **Phase 2: Dockerfile Migration**
   - Migrate Dockerfile for version 22
   - Migrate Dockerfile for version 24
   - Migrate Dockerfile for version 25
   - Migrate Dockerfile for version 26
   - Each migration is a separate atomic commit

3. **Phase 3: Entrypoint Migration**
   - Migrate docker-entrypoint.sh for each version
   - Migrate entrypoint.d/ scripts for each version
   - Each migration is a separate atomic commit

4. **Phase 4: Workflow Configuration**
   - Create .github/workflows/docker.yml
   - Configure matrix strategy with version mapping
   - Configure architecture support per version
   - Add version codename tags
   - Each logical change is a separate atomic commit

5. **Phase 5: Validation**
   - Run hadolint on all Dockerfiles
   - Run shellcheck on all scripts
   - Run yamllint on workflow
   - Fix any issues and commit

6. **Phase 6: Documentation**
   - Update README with new structure
   - Document version support matrix
   - Document build and deployment process

### Commit Strategy

Each atomic commit should:

1. Address a single logical change
2. Pass all lint checks
3. Leave the repository in a working state
4. Follow Conventional Commits format
5. Include descriptive commit message

Example commit sequence:
\`\`\`
feat(docker): create version folder structure
feat(docker): add Ubuntu 22.04 Dockerfile
feat(docker): add Ubuntu 22.04 entrypoint scripts
feat(docker): add Ubuntu 24.04 Dockerfile
feat(docker): add Ubuntu 24.04 entrypoint scripts
feat(docker): add Ubuntu 25.10 Dockerfile
feat(docker): add Ubuntu 25.10 entrypoint scripts
feat(docker): add Ubuntu 26.04 Dockerfile
feat(docker): add Ubuntu 26.04 entrypoint scripts
ci(workflow): add multi-platform build workflow
ci(workflow): configure architecture support per version
ci(workflow): add version codename tags
docs(readme): update with new project structure
\`\`\`

### Cross-Platform Considerations

**Line Endings**:

- Configure `.gitattributes` to enforce LF for shell scripts
- Use `* text=auto` for automatic normalization
- Explicitly set `*.sh text eol=lf`

**Path Separators**:

- Use forward slashes (/) in all paths
- Docker and Git handle forward slashes on all platforms

**Shell Compatibility**:

- Use POSIX-compliant shell (`#!/bin/sh`)
- Avoid Bash-specific features
- Test scripts with `shellcheck --shell=sh`

**File Permissions**:

- Set execute permissions explicitly in Dockerfile: `RUN chmod +x /usr/local/bin/docker-entrypoint.sh`
- Do not rely on Git file permissions

### Security Considerations

**Secrets Management**:

- Never commit secrets to repository
- Use GitHub Secrets for registry credentials
- Use environment variables for runtime secrets

**Image Signing**:

- Sign all published images with Cosign
- Use keyless OIDC signing (no key management)
- Include build metadata in signature

**Vulnerability Management**:

- Scan all images with Trivy before push
- Upload SARIF results to GitHub Security
- Review and remediate HIGH and CRITICAL vulnerabilities

**Supply Chain Security**:

- Generate SBOM for all images (CycloneDX format)
- Include provenance attestation (SLSA)
- Use Harden Runner for egress audit

### Performance Optimization

**Build Cache**:

- Use GitHub Actions cache for Docker layers
- Scope cache by branch and version
- Fallback to main/dev branch cache

**Multi-Platform Builds**:

- Use QEMU for cross-platform emulation
- Use Docker Buildx for parallel builds
- Optimize Dockerfile for layer caching

**Disk Space Management**:

- Remove unnecessary files in same RUN command
- Use jlumbroso/free-disk-space action
- Clean up build artifacts after use

### Monitoring and Observability

**Build Metrics**:

- Track build duration per version
- Track cache hit rate
- Track image size trends

**Security Metrics**:

- Track vulnerability count by severity
- Track time to remediation
- Track signature verification rate

**Deployment Metrics**:

- Track registry push success rate
- Track smoke test pass rate
- Track multi-platform manifest completeness
