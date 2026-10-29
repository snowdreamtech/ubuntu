# Docker Workflow Tag Trigger Testing Guide

## 📋 Overview

This document explains the tag trigger configuration for the Docker multi-platform build workflow and provides testing scenarios to verify the integration with Release-Please.

## 🏷️ Supported Tag Formats

### Primary Format (Release-Please Generated)

The workflow supports Release-Please generated tags:

```yaml
tags:
  - "22-v*" # Matches: 22-v22.04.0, etc.
  - "24-v*" # Matches: 24-v24.04.0, etc.
  - "25-v*" # Matches: 25-v25.10.0, etc.
  - "26-v*" # Matches: 26-v26.04.0, etc.
```

### Legacy Formats (Backward Compatibility)

The workflow maintains backward compatibility with legacy tag formats:

```yaml
tags:
  - "[0-9]+.[0-9]+.[0-9]+" # Matches: 1.2.3, 24.4.0
  - "v[0-9]+.[0-9]+.[0-9]+" # Matches: v1.2.3, v24.4.0
  - "V[0-9]+.[0-9]+.[0-9]+" # Matches: V1.2.3, V24.4.0
  - "ubuntu-*.*.*" # Matches: ubuntu-24.04.0, ubuntu-1.0.0
  - "[0-9]+.[0-9]+" # Matches: 24.04, 22.04
  - "v[0-9]+.[0-9]+" # Matches: v24.04, v22.04
  - "V[0-9]+.[0-9]+" # Matches: V24.04, V22.04
  - "ubuntu-*.*" # Matches: ubuntu-24.04, ubuntu-22.04
  - "[0-9]+" # Matches: 22, 24, 25, 26
  - "v[0-9]+" # Matches: v22, v24, v25, v26
  - "V[0-9]+" # Matches: V22, V24, V25, V26
  - "ubuntu-*" # Matches: ubuntu-24, ubuntu-latest
```

## 🧪 Testing Scenarios

### Scenario 1: Release-Please Tag (Primary Use Case)

**Release-Please Configuration:**

```json
{
  "docker/24": "24.04.0"
}
```

**When you merge a Release-Please PR:**

- Release-Please creates tag: `24-v24.04.0`
- Docker workflow triggers: ✅ YES (matches `24-v*`)
- Matrix job runs: Ubuntu 24 only
- Generated Docker tags:
  - `snowdreamtech/ubuntu:24-v24.04.0`
  - `snowdreamtech/ubuntu:24-latest`
  - `snowdreamtech/ubuntu:latest` (since 24 is `is_latest: true`)
  - `snowdreamtech/ubuntu:noble`
  - `ghcr.io/snowdreamtech/ubuntu:...` (same tags)

### Scenario 2: Legacy Tag Format

**When you push a legacy tag:**

```bash
git tag 22-v22.04.0
git push origin 22-v22.04.0
```

- Docker workflow triggers: ✅ YES (matches `22-v*`)
- Matrix job runs: Ubuntu 22 only
- Generated Docker tags:
  - `snowdreamtech/ubuntu:22-v22.04.0`
  - `snowdreamtech/ubuntu:22-latest`
  - `snowdreamtech/ubuntu:jammy`
  - `ghcr.io/snowdreamtech/ubuntu:...` (same tags)

### Scenario 3: Manual Workflow Dispatch

You can manually trigger builds for specific versions:

1. Go to **Actions** → **🐳 Docker Multi-Platform Build**
2. Click **Run workflow**
3. Select Ubuntu version: `22`, `24`, `25`, `26`, or `all`
4. Choose whether to push images (default: `true`)
5. Click **Run workflow**
