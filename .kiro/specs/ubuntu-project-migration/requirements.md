# Requirements Document

## Introduction

This document defines the requirements for migrating Ubuntu Docker image project code from the legacy ubuntu0 repository to the current ubuntu repository. The migration follows a structured approach using the debian project as a reference standard, ensuring consistency in Docker image structure, build workflows, and cross-platform support.

The migration must maintain atomic commits following Conventional Commits specification, support multiple Ubuntu versions (22.04, 24.04, 25.10, 26.04), and ensure proper architecture support for each version based on official Ubuntu Docker Hub specifications.

## Glossary

- **Current_Project**: The ubuntu repository in the current workspace, using the dev branch as the base
- **Reference_Project**: The debian repository located at /Users/snowdream/Workspace/snowdreamtech/debian (main branch), serving as the standard template
- **Source_Project**: The ubuntu0 repository located at /Users/snowdream/Workspace/snowdreamtech/ubuntu0 (main branch), containing code to be migrated
- **Migration_Agent**: The AI agent or developer executing the migration workflow
- **Version_Folder**: A directory under docker/ representing a specific Ubuntu major version (22, 24, 25, 26)
- **Version_Number**: The full Ubuntu version identifier (22.04, 24.04, 25.10, 26.04)
- **Version_Codename**: The Ubuntu release codename (jammy, noble, questing, resolute)
- **Docker_Tag**: The semantic version tag for Docker images in three-digit format (e.g., 22.04.0)
- **Final_Tag**: The complete Docker image tag combining version and semantic version (e.g., 22-v22.04.0)
- **Architecture**: The CPU architecture supported by a Docker image (amd64, arm64, armhf, ppc64le, s390x)
- **Atomic_Commit**: A single Git commit representing one logical change unit
- **Conventional_Commits**: The commit message specification following @commitlint/config-conventional standard

## Requirements

### Requirement 1: Project Structure Initialization

**User Story:** As a Migration_Agent, I want to establish the base project structure from the Current_Project dev branch, so that I have a clean foundation for migration.

#### Acceptance Criteria

1. THE Migration_Agent SHALL use the Current_Project dev branch as the base for all migration operations
2. WHEN starting the migration, THE Migration_Agent SHALL verify the dev branch exists and is checked out
3. THE Migration_Agent SHALL preserve all existing project configuration files from the Current_Project
4. THE Migration_Agent SHALL maintain the .agent/rules/ directory structure without modification

### Requirement 2: Reference Standard Analysis

**User Story:** As a Migration_Agent, I want to analyze the Reference_Project structure, so that I can apply consistent patterns to the Current_Project.

#### Acceptance Criteria

1. THE Migration_Agent SHALL read the Reference_Project main branch from /Users/snowdream/Workspace/snowdreamtech/debian
2. THE Migration_Agent SHALL identify the standard Dockerfile structure from the Reference_Project
3. THE Migration_Agent SHALL identify the docker-entrypoint.sh pattern from the Reference_Project
4. THE Migration_Agent SHALL identify the entrypoint.d/ script patterns from the Reference_Project
5. THE Migration_Agent SHALL identify the docker.yml workflow structure from the Reference_Project
6. THE Migration_Agent SHALL extract version codename tag patterns from the Reference_Project docker.yml

### Requirement 3: Source Code Migration

**User Story:** As a Migration_Agent, I want to migrate valid code from the Source_Project, so that the Current_Project contains all necessary implementation logic.

#### Acceptance Criteria

1. THE Migration_Agent SHALL read the Source_Project main branch from /Users/snowdream/Workspace/snowdreamtech/ubuntu0
2. WHEN identifying valid code, THE Migration_Agent SHALL extract Dockerfile content from the Source_Project
3. WHEN identifying valid code, THE Migration_Agent SHALL extract docker-entrypoint.sh content from the Source_Project
4. WHEN identifying valid code, THE Migration_Agent SHALL extract entrypoint.d/ scripts from the Source_Project
5. WHEN identifying valid code, THE Migration_Agent SHALL extract GitHub workflow configurations from the Source_Project
6. THE Migration_Agent SHALL align migrated content with Reference_Project patterns while allowing system-specific differences between Debian and Ubuntu

### Requirement 4: Version Folder Management

**User Story:** As a Migration_Agent, I want to maintain version-specific folders, so that each Ubuntu version has isolated configuration.

#### Acceptance Criteria

1. THE Migration_Agent SHALL create or maintain Version_Folders for versions 22, 24, 25, and 26 under the docker/ directory
2. FOR ALL Version_Folders, THE Migration_Agent SHALL ensure each contains a Dockerfile
3. FOR ALL Version_Folders, THE Migration_Agent SHALL ensure each contains a docker-entrypoint.sh script
4. WHERE entrypoint.d/ scripts exist, THE Migration_Agent SHALL place them in the appropriate Version_Folder
5. THE Migration_Agent SHALL map Version_Folders to Version_Numbers: 22→22.04, 24→24.04, 25→25.10, 26→26.04

### Requirement 5: Dockerfile Standardization

**User Story:** As a Migration_Agent, I want to standardize Dockerfiles across all versions, so that they follow consistent patterns and reference official Ubuntu base images.

#### Acceptance Criteria

1. FOR ALL Dockerfiles, THE Migration_Agent SHALL use the FROM directive with official Ubuntu base images
2. WHEN writing the FROM directive for version 22, THE Migration_Agent SHALL use "FROM ubuntu:22.04"
3. WHEN writing the FROM directive for version 24, THE Migration_Agent SHALL use "FROM ubuntu:24.04"
4. WHEN writing the FROM directive for version 25, THE Migration_Agent SHALL use "FROM ubuntu:25.10"
5. WHEN writing the FROM directive for version 26, THE Migration_Agent SHALL use "FROM ubuntu:26.04"
6. THE Migration_Agent SHALL align Dockerfile content structure with the Reference_Project while accommodating Ubuntu-specific package names and system differences

### Requirement 6: Docker Tag Specification

**User Story:** As a Migration_Agent, I want to apply consistent Docker image tagging, so that images follow semantic versioning and include version prefixes.

#### Acceptance Criteria

1. THE Migration_Agent SHALL use three-digit semantic versioning for Docker_Tags (e.g., 22.04.0)
2. THE Migration_Agent SHALL construct Final_Tags by combining the major version with the Docker_Tag
3. WHEN creating a Final_Tag for version 22.04.0, THE Migration_Agent SHALL produce "22-v22.04.0"
4. WHEN creating a Final_Tag for version 24.04.0, THE Migration_Agent SHALL produce "24-v24.04.0"
5. WHEN creating a Final_Tag for version 25.10.0, THE Migration_Agent SHALL produce "25-v25.10.0"
6. WHEN creating a Final_Tag for version 26.04.0, THE Migration_Agent SHALL produce "26-v26.04.0"

### Requirement 7: Architecture Support Configuration

**User Story:** As a Migration_Agent, I want to configure architecture support per version, so that each Ubuntu version builds for its officially supported platforms.

#### Acceptance Criteria

1. THE Migration_Agent SHALL reference https://hub.docker.com/_/ubuntu for official Architecture support information
2. THE Migration_Agent SHALL reference the Source_Project GitHub workflow for existing Architecture configurations
3. FOR ALL Version_Numbers, THE Migration_Agent SHALL configure the docker.yml workflow with the correct Architecture list
4. WHEN Architecture support differs between versions, THE Migration_Agent SHALL apply version-specific Architecture configurations
5. THE Migration_Agent SHALL document Architecture support decisions in commit messages or workflow comments

### Requirement 8: Version Codename Tag Support

**User Story:** As a Migration_Agent, I want to add version codename tags to the docker.yml workflow, so that Docker images can be referenced by Ubuntu release codenames.

#### Acceptance Criteria

1. THE Migration_Agent SHALL modify the docker.yml workflow to include Version_Codename tags
2. WHEN configuring version 22.04, THE Migration_Agent SHALL add the "jammy" tag
3. WHEN configuring version 24.04, THE Migration_Agent SHALL add the "noble" and "latest" tags
4. WHEN configuring version 25.10, THE Migration_Agent SHALL add the "questing" tag
5. WHEN configuring version 26.04, THE Migration_Agent SHALL add the "resolute" tag
6. THE Migration_Agent SHALL reference the Reference_Project docker.yml for tag configuration patterns

### Requirement 9: Atomic Commit Execution

**User Story:** As a Migration_Agent, I want to execute changes atomically, so that each logical change is isolated in version control.

#### Acceptance Criteria

1. THE Migration_Agent SHALL create one Atomic_Commit for each independent logical change
2. WHEN completing a logical change unit, THE Migration_Agent SHALL immediately commit before proceeding to the next change
3. THE Migration_Agent SHALL NOT batch multiple unrelated changes into a single commit
4. THE Migration_Agent SHALL NOT leave the repository in a broken or inconsistent state after any commit
5. THE Migration_Agent SHALL run lint and format auto-fixes before each commit

### Requirement 10: Conventional Commits Compliance

**User Story:** As a Migration_Agent, I want to write commit messages following Conventional Commits specification, so that the commit history is standardized and machine-readable.

#### Acceptance Criteria

1. THE Migration_Agent SHALL format all commit messages as "<type>(<scope>): <description>"
2. THE Migration_Agent SHALL write commit message headers in English only
3. THE Migration_Agent SHALL limit commit message headers to 120 characters maximum
4. THE Migration_Agent SHALL use imperative mood in commit message descriptions
5. THE Migration_Agent SHALL NOT end commit message headers with a period
6. WHEN committing Dockerfile changes, THE Migration_Agent SHALL use type "feat" or "fix" with scope "docker"
7. WHEN committing workflow changes, THE Migration_Agent SHALL use type "ci" with scope "workflow" or "github-actions"
8. WHEN committing script changes, THE Migration_Agent SHALL use type "feat", "fix", or "refactor" with scope "scripts"

### Requirement 11: Auto-Commit Without Push

**User Story:** As a Migration_Agent, I want to automatically commit changes without pushing, so that the developer retains control over remote repository state.

#### Acceptance Criteria

1. THE Migration_Agent SHALL automatically execute git commit after each logical change
2. THE Migration_Agent SHALL NOT automatically execute git push to remote repositories
3. THE Migration_Agent SHALL allow the developer to review all commits locally before pushing
4. THE Migration_Agent SHALL NOT use the --no-verify flag when committing
5. IF pre-commit hooks fail, THEN THE Migration_Agent SHALL fix the underlying issue before retrying the commit

### Requirement 12: Cross-Platform Compatibility

**User Story:** As a Migration_Agent, I want to ensure all scripts and configurations work across platforms, so that the project supports Linux, macOS, and Windows development environments.

#### Acceptance Criteria

1. THE Migration_Agent SHALL use relative paths in all scripts and configurations
2. THE Migration_Agent SHALL NOT use absolute paths starting with /Users/, C:\, or ~
3. WHEN creating shell scripts, THE Migration_Agent SHALL ensure POSIX compliance
4. THE Migration_Agent SHALL configure .gitattributes to normalize line endings
5. THE Migration_Agent SHALL ensure docker-entrypoint.sh uses LF line endings

### Requirement 13: AI Rules Compliance

**User Story:** As a Migration_Agent, I want to follow all project AI rules, so that the migration adheres to established project standards.

#### Acceptance Criteria

1. THE Migration_Agent SHALL read and follow all rules in .agent/rules/ before executing migration tasks
2. THE Migration_Agent SHALL apply the Triple Guarantee Quality Mechanism for all code changes
3. THE Migration_Agent SHALL use Simplified Chinese for user communication
4. THE Migration_Agent SHALL use English for all code, comments, and commit messages
5. THE Migration_Agent SHALL maintain idempotency in all scripts and configurations

### Requirement 14: Content Alignment with System Differences

**User Story:** As a Migration_Agent, I want to align content structure with the Reference_Project while respecting system differences, so that Ubuntu-specific requirements are properly handled.

#### Acceptance Criteria

1. THE Migration_Agent SHALL use the Reference_Project as the structural template for Dockerfiles
2. THE Migration_Agent SHALL use the Reference_Project as the structural template for docker-entrypoint.sh
3. THE Migration_Agent SHALL use the Reference_Project as the structural template for entrypoint.d/ scripts
4. WHEN Ubuntu requires different package names than Debian, THE Migration_Agent SHALL use Ubuntu-appropriate package names
5. WHEN Ubuntu requires different system commands than Debian, THE Migration_Agent SHALL use Ubuntu-appropriate commands
6. THE Migration_Agent SHALL document significant system differences in code comments

### Requirement 15: Lint and Format Verification

**User Story:** As a Migration_Agent, I want to verify all changes pass linting and formatting checks, so that code quality standards are maintained.

#### Acceptance Criteria

1. THE Migration_Agent SHALL run ShellCheck on all .sh scripts before committing
2. THE Migration_Agent SHALL run hadolint on all Dockerfiles before committing
3. THE Migration_Agent SHALL run yamllint on all .yml workflow files before committing
4. THE Migration_Agent SHALL apply auto-fix for all fixable linting issues
5. IF linting issues cannot be auto-fixed, THEN THE Migration_Agent SHALL manually resolve them before committing

### Requirement 16: Workspace Path Resolution

**User Story:** As a Migration_Agent, I want to correctly resolve workspace paths, so that I access the correct project directories.

#### Acceptance Criteria

1. THE Migration_Agent SHALL recognize the Current_Project is in the "ubuntu" folder of the workspace
2. THE Migration_Agent SHALL recognize the Source_Project is in the "ununtu0" folder of the workspace (note the spelling)
3. THE Migration_Agent SHALL use relative paths from the workspace root when accessing Current_Project files
4. THE Migration_Agent SHALL use relative paths from the workspace root when accessing Source_Project files
5. THE Migration_Agent SHALL NOT attempt to access /Users/snowdream/Workspace/snowdreamtech/debian directly (it is outside the workspace)
