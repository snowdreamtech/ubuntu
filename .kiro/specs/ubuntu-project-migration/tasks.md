# Implementation Plan: Ubuntu Project Migration

## Overview

This implementation plan guides the migration of Ubuntu Docker image project code from the legacy ubuntu0 repository to the current ubuntu repository. The migration follows a structured, atomic approach using the debian project as a reference standard, ensuring consistency in Docker image structure, build workflows, and cross-platform support.

The implementation is organized into discrete, atomic tasks that can be executed independently and committed following Conventional Commits specification. Each task includes validation steps (lint, format, test) and clear references to requirements.

## Tasks

- [x] 1. Initialize project foundation and verify environment
  - Verify the dev branch exists and is checked out in the ubuntu project
  - Verify access to the ununtu0 project (note the spelling) in the workspace
  - Create the docker/ directory structure if it doesn't exist
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 16.1, 16.2_

- [x] 2. Analyze reference project structure
  - Read and analyze the debian project structure from /Users/snowdream/Workspace/snowdreamtech/debian
  - Document the standard Dockerfile patterns used in debian
  - Document the docker-entrypoint.sh patterns used in debian
  - Document the entrypoint.d/ script patterns used in debian
  - Document the GitHub workflow structure from debian's docker.yml
  - Extract version codename tag patterns from debian's docker.yml
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6_

- [x] 3. Create version folder structure
  - Create docker/22/ folder for Ubuntu 22.04 (Jammy)
  - Create docker/24/ folder for Ubuntu 24.04 (Noble)
  - Create docker/25/ folder for Ubuntu 25.10 (Questing)
  - Create docker/26/ folder for Ubuntu 26.04 (Resolute)
  - Commit with message: "feat(docker): create version folder structure for Ubuntu 22, 24, 25, 26"
  - _Requirements: 4.1, 4.5, 9.1, 9.2, 10.1, 10.2, 10.3, 10.4, 10.5_

- [x] 4. Migrate Ubuntu 22.04 (Jammy) Dockerfile
  - [x] 4.1 Create Dockerfile for Ubuntu 22.04
    - Read the source Dockerfile from ununtu0 project
    - Align structure with debian reference project patterns
    - Use FROM ubuntu:22.04 as base image
    - Add OCI labels following the design specification
    - Configure environment variables (LANG, DEBIAN_FRONTEND, DEBUG, PUID, PGID, USER, WORKDIR, etc.)
    - Install essential packages (curl, git, vim, jq, gosu, network utilities)
    - Copy and configure entrypoint scripts
    - _Requirements: 3.2, 5.1, 5.2, 5.6, 14.1, 14.4, 14.5_

  - [x] 4.2 Validate Dockerfile with hadolint
    - Run hadolint on docker/22/Dockerfile
    - Fix any linting issues found
    - _Requirements: 15.2, 15.4_

  - [x] 4.3 Commit Ubuntu 22.04 Dockerfile
    - Run lint and format auto-fixes
    - Commit with message: "feat(docker): add Ubuntu 22.04 Dockerfile with OCI labels and essential packages"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.6, 11.1, 11.2_

- [-] 5. Migrate Ubuntu 22.04 (Jammy) entrypoint scripts
  - [x] 5.1 Create docker-entrypoint.sh for Ubuntu 22.04
    - Read the source docker-entrypoint.sh from ununtu0 project
    - Align structure with debian reference project patterns
    - Use POSIX-compliant shell (#!/bin/sh)
    - Implement fail-fast behavior (set -e)
    - Support conditional debug logging
    - Iterate through /usr/local/bin/entrypoint.d/* scripts
    - Ensure LF line endings
    - _Requirements: 3.3, 4.3, 12.3, 12.5, 14.2, 14.5_

  - [x] 5.2 Create entrypoint.d/ scripts for Ubuntu 22.04
    - Create docker/22/entrypoint.d/ directory
    - Migrate 00-base-init.sh (early initialization)
    - Migrate 01-base-setup.sh (configuration setup)
    - Migrate 99-base-end.sh (final setup steps)
    - Ensure all scripts are POSIX-compliant
    - Ensure all scripts use LF line endings
    - _Requirements: 3.4, 4.4, 12.3, 12.5, 14.3, 14.5_

  - [x] 5.3 Validate entrypoint scripts with ShellCheck
    - Run ShellCheck on docker/22/docker-entrypoint.sh
    - Run ShellCheck on all docker/22/entrypoint.d/*.sh scripts
    - Fix any linting issues found
    - _Requirements: 15.1, 15.4_

  - [x] 5.4 Commit Ubuntu 22.04 entrypoint scripts
    - Run lint and format auto-fixes
    - Commit with message: "feat(scripts): add Ubuntu 22.04 entrypoint scripts with modular initialization"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.8, 11.1, 11.2_

- [x] 6. Migrate Ubuntu 24.04 (Noble) Dockerfile
  - [x] 6.1 Create Dockerfile for Ubuntu 24.04
    - Read the source Dockerfile from ununtu0 project
    - Align structure with debian reference project patterns
    - Use FROM ubuntu:24.04 as base image
    - Add OCI labels following the design specification
    - Configure environment variables
    - Install essential packages
    - Copy and configure entrypoint scripts
    - _Requirements: 3.2, 5.1, 5.3, 5.6, 14.1, 14.4, 14.5_

  - [x] 6.2 Validate Dockerfile with hadolint
    - Run hadolint on docker/24/Dockerfile
    - Fix any linting issues found
    - _Requirements: 15.2, 15.4_

  - [x] 6.3 Commit Ubuntu 24.04 Dockerfile
    - Run lint and format auto-fixes
    - Commit with message: "feat(docker): add Ubuntu 24.04 Dockerfile with OCI labels and essential packages"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.6, 11.1, 11.2_

- [x] 7. Migrate Ubuntu 24.04 (Noble) entrypoint scripts
  - [x] 7.1 Create docker-entrypoint.sh for Ubuntu 24.04
    - Read the source docker-entrypoint.sh from ununtu0 project
    - Align structure with debian reference project patterns
    - Use POSIX-compliant shell (#!/bin/sh)
    - Implement fail-fast behavior (set -e)
    - Support conditional debug logging
    - Ensure LF line endings
    - _Requirements: 3.3, 4.3, 12.3, 12.5, 14.2, 14.5_

  - [x] 7.2 Create entrypoint.d/ scripts for Ubuntu 24.04
    - Create docker/24/entrypoint.d/ directory
    - Migrate 00-base-init.sh, 01-base-setup.sh, 99-base-end.sh
    - Ensure all scripts are POSIX-compliant
    - Ensure all scripts use LF line endings
    - _Requirements: 3.4, 4.4, 12.3, 12.5, 14.3, 14.5_

  - [x] 7.3 Validate entrypoint scripts with ShellCheck
    - Run ShellCheck on docker/24/docker-entrypoint.sh
    - Run ShellCheck on all docker/24/entrypoint.d/*.sh scripts
    - Fix any linting issues found
    - _Requirements: 15.1, 15.4_

  - [x] 7.4 Commit Ubuntu 24.04 entrypoint scripts
    - Run lint and format auto-fixes
    - Commit with message: "feat(scripts): add Ubuntu 24.04 entrypoint scripts with modular initialization"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.8, 11.1, 11.2_

- [-] 8. Migrate Ubuntu 25.10 (Questing) Dockerfile
  - [x] 8.1 Create Dockerfile for Ubuntu 25.10
    - Read the source Dockerfile from ununtu0 project
    - Align structure with debian reference project patterns
    - Use FROM ubuntu:25.10 as base image
    - Add OCI labels following the design specification
    - Configure environment variables
    - Install essential packages
    - Copy and configure entrypoint scripts
    - _Requirements: 3.2, 5.1, 5.4, 5.6, 14.1, 14.4, 14.5_

  - [x] 8.2 Validate Dockerfile with hadolint
    - Run hadolint on docker/25/Dockerfile
    - Fix any linting issues found
    - _Requirements: 15.2, 15.4_

  - [x] 8.3 Commit Ubuntu 25.10 Dockerfile
    - Run lint and format auto-fixes
    - Commit with message: "feat(docker): add Ubuntu 25.10 Dockerfile with OCI labels and essential packages"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.6, 11.1, 11.2_

- [x] 9. Migrate Ubuntu 25.10 (Questing) entrypoint scripts
  - [x] 9.1 Create docker-entrypoint.sh for Ubuntu 25.10
    - Read the source docker-entrypoint.sh from ununtu0 project
    - Align structure with debian reference project patterns
    - Use POSIX-compliant shell (#!/bin/sh)
    - Implement fail-fast behavior (set -e)
    - Support conditional debug logging
    - Ensure LF line endings
    - _Requirements: 3.3, 4.3, 12.3, 12.5, 14.2, 14.5_

  - [x] 9.2 Create entrypoint.d/ scripts for Ubuntu 25.10
    - Create docker/25/entrypoint.d/ directory
    - Migrate 00-base-init.sh, 01-base-setup.sh, 99-base-end.sh
    - Ensure all scripts are POSIX-compliant
    - Ensure all scripts use LF line endings
    - _Requirements: 3.4, 4.4, 12.3, 12.5, 14.3, 14.5_

  - [x] 9.3 Validate entrypoint scripts with ShellCheck
    - Run ShellCheck on docker/25/docker-entrypoint.sh
    - Run ShellCheck on all docker/25/entrypoint.d/*.sh scripts
    - Fix any linting issues found
    - _Requirements: 15.1, 15.4_

  - [x] 9.4 Commit Ubuntu 25.10 entrypoint scripts
    - Run lint and format auto-fixes
    - Commit with message: "feat(scripts): add Ubuntu 25.10 entrypoint scripts with modular initialization"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.8, 11.1, 11.2_

- [-] 10. Migrate Ubuntu 26.04 (Resolute) Dockerfile
  - [x] 10.1 Create Dockerfile for Ubuntu 26.04
    - Read the source Dockerfile from ununtu0 project
    - Align structure with debian reference project patterns
    - Use FROM ubuntu:26.04 as base image
    - Add OCI labels following the design specification
    - Configure environment variables
    - Install essential packages
    - Copy and configure entrypoint scripts
    - _Requirements: 3.2, 5.1, 5.5, 5.6, 14.1, 14.4, 14.5_

  - [x] 10.2 Validate Dockerfile with hadolint
    - Run hadolint on docker/26/Dockerfile
    - Fix any linting issues found
    - _Requirements: 15.2, 15.4_

  - [x] 10.3 Commit Ubuntu 26.04 Dockerfile
    - Run lint and format auto-fixes
    - Commit with message: "feat(docker): add Ubuntu 26.04 Dockerfile with OCI labels and essential packages"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.6, 11.1, 11.2_

- [x] 11. Migrate Ubuntu 26.04 (Resolute) entrypoint scripts
  - [x] 11.1 Create docker-entrypoint.sh for Ubuntu 26.04
    - Read the source docker-entrypoint.sh from ununtu0 project
    - Align structure with debian reference project patterns
    - Use POSIX-compliant shell (#!/bin/sh)
    - Implement fail-fast behavior (set -e)
    - Support conditional debug logging
    - Ensure LF line endings
    - _Requirements: 3.3, 4.3, 12.3, 12.5, 14.2, 14.5_

  - [x] 11.2 Create entrypoint.d/ scripts for Ubuntu 26.04
    - Create docker/26/entrypoint.d/ directory
    - Migrate 00-base-init.sh, 01-base-setup.sh, 99-base-end.sh
    - Ensure all scripts are POSIX-compliant
    - Ensure all scripts use LF line endings
    - _Requirements: 3.4, 4.4, 12.3, 12.5, 14.3, 14.5_

  - [x] 11.3 Validate entrypoint scripts with ShellCheck
    - Run ShellCheck on docker/26/docker-entrypoint.sh
    - Run ShellCheck on all docker/26/entrypoint.d/*.sh scripts
    - Fix any linting issues found
    - _Requirements: 15.1, 15.4_

  - [x] 11.4 Commit Ubuntu 26.04 entrypoint scripts
    - Run lint and format auto-fixes
    - Commit with message: "feat(scripts): add Ubuntu 26.04 entrypoint scripts with modular initialization"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.8, 11.1, 11.2_

- [x] 12. Checkpoint - Verify all Dockerfiles and scripts
  - Ensure all Dockerfiles pass hadolint validation
  - Ensure all shell scripts pass ShellCheck validation
  - Verify all version folders have complete structure (Dockerfile, docker-entrypoint.sh, entrypoint.d/)
  - Ask the user if questions arise
  - _Requirements: 15.1, 15.2, 15.4_

- [-] 13. Create GitHub Actions workflow foundation
  - [x] 13.1 Create .github/workflows/docker.yml
    - Read the source workflow from ununtu0 project
    - Align structure with debian reference project workflow
    - Configure workflow triggers (push to main/dev, tag push, schedule, manual dispatch)
    - Set up workflow permissions (contents: read, packages: write, id-token: write, security-events: write, attestations: write)
    - Configure environment variables and secrets
    - _Requirements: 3.5, 14.1_

  - [x] 13.2 Configure matrix strategy for version management
    - Define matrix with version, codename, and is_latest flags
    - Version 22: codename "jammy", is_latest false
    - Version 24: codename "noble", is_latest true
    - Version 25: codename "questing", is_latest false
    - Version 26: codename "resolute", is_latest false
    - _Requirements: 4.5, 8.2, 8.3, 8.4, 8.5_

  - [x] 13.3 Validate workflow with yamllint
    - Run yamllint on .github/workflows/docker.yml
    - Fix any YAML syntax or formatting issues
    - _Requirements: 15.3, 15.4_

  - [x] 13.4 Commit GitHub Actions workflow foundation
    - Run lint and format auto-fixes
    - Commit with message: "ci(workflow): add multi-platform Docker build workflow with version matrix"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.7, 11.1, 11.2_

- [x] 14. Configure architecture support per version
  - [x] 14.1 Add architecture configuration for Ubuntu 22.04
    - Reference https://hub.docker.com/_/ubuntu for official architecture support
    - Configure platforms: linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x
    - Add architecture configuration to workflow matrix or build step
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [x] 14.2 Add architecture configuration for Ubuntu 24.04
    - Reference https://hub.docker.com/_/ubuntu for official architecture support
    - Configure platforms: linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64
    - Add architecture configuration to workflow matrix or build step
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [x] 14.3 Add architecture configuration for Ubuntu 25.10
    - Reference https://hub.docker.com/_/ubuntu for official architecture support
    - Configure platforms: linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64
    - Add architecture configuration to workflow matrix or build step
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [x] 14.4 Add architecture configuration for Ubuntu 26.04
    - Reference https://hub.docker.com/_/ubuntu for official architecture support
    - Configure platforms: linux/amd64, linux/arm64, linux/armhf, linux/ppc64le, linux/s390x, linux/riscv64
    - Add architecture configuration to workflow matrix or build step
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [x] 14.5 Document architecture support decisions
    - Add comments in workflow explaining architecture differences between versions
    - Document why Ubuntu 22.04 has 5 platforms while 24/25/26 have 6 platforms
    - _Requirements: 7.5_

  - [x] 14.6 Validate workflow with yamllint
    - Run yamllint on .github/workflows/docker.yml
    - Fix any YAML syntax or formatting issues
    - _Requirements: 15.3, 15.4_

  - [x] 14.7 Commit architecture support configuration
    - Run lint and format auto-fixes
    - Commit with message: "ci(workflow): configure architecture support per Ubuntu version"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.7, 11.1, 11.2_

- [x] 15. Add version codename tags to workflow
  - [x] 15.1 Configure tag generation logic
    - Reference debian project docker.yml for tag configuration patterns
    - Implement tag generation based on version, codename, and is_latest flags
    - Support version-prefixed tags (22-dev, 24-main, 22-latest, 24-latest)
    - Support semantic version tags (22.04.0, 24.04.0)
    - Support version-prefixed semantic tags (22-v22.04.0, 24-v24.04.0)
    - Support nightly tags (22-nightly, 24-nightly)
    - Support date tags (22-20250115, 24-20250115)
    - _Requirements: 2.6, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 8.6_

  - [x] 15.2 Add codename tags for all versions
    - Add "jammy" tag for Ubuntu 22.04
    - Add "noble" and "latest" tags for Ubuntu 24.04
    - Add "questing" tag for Ubuntu 25.10
    - Add "resolute" tag for Ubuntu 26.04
    - Add codename-latest tags (jammy-latest, noble-latest, questing-latest, resolute-latest)
    - _Requirements: 8.2, 8.3, 8.4, 8.5_

  - [x] 15.3 Validate workflow with yamllint
    - Run yamllint on .github/workflows/docker.yml
    - Fix any YAML syntax or formatting issues
    - _Requirements: 15.3, 15.4_

  - [x] 15.4 Commit version codename tags
    - Run lint and format auto-fixes
    - Commit with message: "ci(workflow): add version codename tags and comprehensive tag strategy"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.7, 11.1, 11.2_

- [x] 16. Add security and quality features to workflow
  - [x] 16.1 Add Harden Runner for egress audit
    - Add step-security/harden-runner action
    - Configure egress policy and allowed endpoints
    - _Requirements: 3.5_

  - [x] 16.2 Add Trivy vulnerability scanning
    - Add aquasecurity/trivy-action for image scanning
    - Configure severity levels (CRITICAL, HIGH)
    - Upload SARIF results to GitHub Security tab
    - _Requirements: 3.5_

  - [x] 16.3 Add SBOM generation
    - Configure Docker Buildx to generate SBOM in CycloneDX format
    - Attach SBOM to image as attestation
    - _Requirements: 3.5_

  - [x] 16.4 Add provenance attestation
    - Configure Docker Buildx to generate SLSA provenance
    - Attach provenance to image as attestation
    - _Requirements: 3.5_

  - [x] 16.5 Add Cosign image signing
    - Add sigstore/cosign-installer action
    - Configure keyless OIDC signing
    - Sign all published images
    - _Requirements: 3.5_

  - [x] 16.6 Add smoke tests for all registries
    - Add smoke test steps for DockerHub images
    - Add smoke test steps for GHCR images
    - Add smoke test steps for Quay.io images
    - Test basic functionality (entrypoint, timezone, user context, tools)
    - _Requirements: 3.5_

  - [x] 16.7 Validate workflow with yamllint and actionlint
    - Run yamllint on .github/workflows/docker.yml
    - Run actionlint on .github/workflows/docker.yml (if available)
    - Fix any issues found
    - _Requirements: 15.3, 15.4_

  - [x] 16.8 Commit security and quality features
    - Run lint and format auto-fixes
    - Commit with message: "ci(workflow): add security scanning, SBOM, provenance, signing, and smoke tests"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 10.7, 11.1, 11.2_

- [x] 17. Configure cross-platform compatibility
  - [x] 17.1 Create or update .gitattributes
    - Configure text file normalization (* text=auto)
    - Enforce LF line endings for shell scripts (*.sh text eol=lf)
    - Enforce LF line endings for entrypoint scripts (docker-entrypoint.sh text eol=lf)
    - _Requirements: 12.4, 12.5_

  - [x] 17.2 Verify relative paths in all files
    - Scan all Dockerfiles for absolute paths
    - Scan all shell scripts for absolute paths
    - Scan workflow files for absolute paths
    - Replace any absolute paths with relative paths
    - _Requirements: 12.1, 12.2, 16.3, 16.4_

  - [x] 17.3 Commit cross-platform compatibility configuration
    - Run lint and format auto-fixes
    - Commit with message: "chore(config): configure cross-platform compatibility with LF line endings"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 11.1, 11.2_

- [x] 18. Update project documentation
  - [x] 18.1 Update README.md with new structure
    - Document the version folder structure (docker/22, docker/24, docker/25, docker/26)
    - Document version mapping (22→22.04, 24→24.04, 25→25.10, 26→26.04)
    - Document codename mapping (22→jammy, 24→noble, 25→questing, 26→resolute)
    - Document supported architectures per version
    - Document Docker image tags and naming conventions
    - Document build and deployment process
    - _Requirements: 4.5, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 7.3, 7.4, 8.2, 8.3, 8.4, 8.5_

  - [x] 18.2 Add usage examples to README.md
    - Add examples for pulling images from different registries
    - Add examples for running containers with different configurations
    - Add examples for using environment variables (DEBUG, PUID, PGID, USER, WORKDIR)
    - Add examples for building images locally
    - _Requirements: 13.3, 13.4_

  - [x] 18.3 Document migration decisions
    - Document significant differences between Debian and Ubuntu implementations
    - Document package name differences
    - Document system command differences
    - _Requirements: 14.6_

  - [x] 18.4 Commit documentation updates
    - Run lint and format auto-fixes
    - Commit with message: "docs(readme): update documentation with new project structure and usage examples"
    - _Requirements: 9.1, 9.2, 9.4, 9.5, 11.1, 11.2_

- [x] 19. Final validation and testing
  - [x] 19.1 Run comprehensive lint checks
    - Run hadolint on all Dockerfiles (docker/*/Dockerfile)
    - Run ShellCheck on all shell scripts (docker/*/docker-entrypoint.sh, docker/*/entrypoint.d/*.sh)
    - Run yamllint on all workflow files (.github/workflows/*.yml)
    - Fix any remaining issues
    - _Requirements: 15.1, 15.2, 15.3, 15.4, 15.5_

  - [x] 19.2 Run local integration tests
    - Build Docker images locally for each version (docker build -t ubuntu-test:22 docker/22/)
    - Test container startup for each version (docker run --rm ubuntu-test:22 echo "Hello")
    - Test entrypoint execution with DEBUG=true
    - Test non-root user creation with PUID/PGID
    - Test essential tools availability (curl, git, jq, vim)
    - _Requirements: 9.4_

  - [x] 19.3 Verify commit history
    - Review all commit messages for Conventional Commits compliance
    - Verify each commit is atomic and represents a single logical change
    - Verify no commits contain multiple unrelated changes
    - Verify all commit messages are in English
    - _Requirements: 9.1, 9.2, 9.3, 10.1, 10.2, 10.3, 10.4, 10.5_

  - [x] 19.4 Verify no auto-push occurred
    - Confirm all commits are local only
    - Confirm no git push commands were executed automatically
    - Inform user that commits are ready for review and manual push
    - _Requirements: 11.2, 11.3_

- [x] 20. Final checkpoint - Migration complete
  - Ensure all tests pass and all lint checks pass
  - Verify all version folders are complete and consistent
  - Verify GitHub Actions workflow is properly configured
  - Verify documentation is up to date
  - Ask the user if questions arise or if they want to proceed with pushing commits
  - _Requirements: 9.4, 11.3_

## Notes

- Tasks marked with `*` are optional validation tasks that can be skipped for faster migration
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation at key milestones
- All commits follow Conventional Commits specification
- No automatic push to remote - user retains control over when to push
- Cross-platform compatibility is ensured through relative paths and LF line endings
- Architecture support varies by Ubuntu version (22.04 has 5 platforms, 24/25/26 have 6 platforms)
- Version codename tags enable user-friendly image references (jammy, noble, questing, resolute)
- Security features include vulnerability scanning, SBOM generation, provenance attestation, and image signing
- Smoke tests validate functionality across all container registries (DockerHub, GHCR, Quay.io)
