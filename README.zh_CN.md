# Ubuntu Docker 镜像

[![CI 流水线](https://img.shields.io/github/actions/workflow/status/snowdreamtech/ubuntu/ci.yml?branch=main&label=CI%20Pipeline)](https://github.com/snowdreamtech/ubuntu/actions/workflows/ci.yml)
[![CD 流水线](https://img.shields.io/github/actions/workflow/status/snowdreamtech/ubuntu/cd.yml?branch=main&label=CD%20Pipeline)](https://github.com/snowdreamtech/ubuntu/actions/workflows/cd.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/snowdreamtech/ubuntu?logo=docker)](https://hub.docker.com/r/snowdreamtech/ubuntu)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-snowdreamtech%2Fubuntu-blue?logo=github)](https://github.com/snowdreamtech/ubuntu/pkgs/container/ubuntu)
[![多架构支持](https://img.shields.io/badge/架构-6-blue)](https://github.com/snowdreamtech/ubuntu)
[![许可证: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/license/MIT)
[![发布版本](https://img.shields.io/github/v/release/snowdreamtech/ubuntu?logo=github&sort=semver)](https://github.com/snowdreamtech/ubuntu/releases/latest)

[English](README.md) | [简体中文](README.zh_CN.md)

企业级 Ubuntu Docker 基础镜像，提供全面的多架构支持和生产就绪的配置。

## 🌟 特性

- **多架构支持**：原生支持最多 6 种架构（amd64、arm64、armhf、ppc64le、s390x、riscv64）
- **多版本支持**：Ubuntu 22.04（Jammy）、24.04（Noble）、25.10（Questing）和 26.04（Resolute）
- **精简基础**：基于官方 Ubuntu 基础镜像构建，确保最佳兼容性
- **生产就绪**：预配置了必要工具和安全加固
- **灵活的用户管理**：支持自定义 PUID/PGID
- **模块化入口点系统**：可扩展的初始化脚本
- **自动化构建**：CI/CD 流水线，自动测试和发布

## 📦 支持的版本

| 版本 | 代号 | 基础镜像 | Docker 标签 | 状态 |
|------|------|----------|-------------|------|
| 26 | Resolute | ubuntu:26.04 | `26-latest`, `26-v26.04.0`, `resolute` | ✅ 活跃 |
| 25 | Questing | ubuntu:25.10 | `25-latest`, `25-v25.10.0`, `questing` | ✅ 活跃 |
| 24 | Noble | ubuntu:24.04 | `latest`, `24-latest`, `24-v24.04.0`, `noble` | ✅ 活跃 |
| 22 | Jammy | ubuntu:22.04 | `22-latest`, `22-v22.04.0`, `jammy` | ✅ 活跃 |

## 🚀 快速开始

### 从 Docker Hub 拉取

```bash
# 最新版本（Ubuntu 24.04 Noble）
docker pull snowdreamtech/ubuntu:latest

# Ubuntu 26.04（Resolute）
docker pull snowdreamtech/ubuntu:26-latest
docker pull snowdreamtech/ubuntu:26-v26.04.0
docker pull snowdreamtech/ubuntu:resolute

# Ubuntu 25.10（Questing）
docker pull snowdreamtech/ubuntu:25-latest
docker pull snowdreamtech/ubuntu:25-v25.10.0
docker pull snowdreamtech/ubuntu:questing

# Ubuntu 24.04（Noble）
docker pull snowdreamtech/ubuntu:24-latest
docker pull snowdreamtech/ubuntu:24-v24.04.0
docker pull snowdreamtech/ubuntu:noble

# Ubuntu 22.04（Jammy）
docker pull snowdreamtech/ubuntu:22-latest
docker pull snowdreamtech/ubuntu:22-v22.04.0
docker pull snowdreamtech/ubuntu:jammy
```

### 从 GitHub Container Registry 拉取

```bash
# 最新版本（Ubuntu 24.04 Noble）
docker pull ghcr.io/snowdreamtech/ubuntu:latest

# Ubuntu 24.04（Noble）
docker pull ghcr.io/snowdreamtech/ubuntu:24-latest
docker pull ghcr.io/snowdreamtech/ubuntu:24-v24.04.0
docker pull ghcr.io/snowdreamtech/ubuntu:noble

# Ubuntu 22.04（Jammy）
docker pull ghcr.io/snowdreamtech/ubuntu:22-latest
docker pull ghcr.io/snowdreamtech/ubuntu:22-v22.04.0
docker pull ghcr.io/snowdreamtech/ubuntu:jammy
```

### 基本使用

```bash
# 运行交互式 shell
docker run -it snowdreamtech/ubuntu:latest

# 使用自定义用户运行
docker run -it \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  snowdreamtech/ubuntu:latest

# 在后台保持容器运行
docker run -d \
  -e KEEPALIVE=1 \
  --name my-ubuntu \
  snowdreamtech/ubuntu:latest

# 启用调试输出运行
docker run -it \
  -e DEBUG=true \
  snowdreamtech/ubuntu:latest
```

## 🏗️ 架构

### 支持的平台

| 架构 | Ubuntu 22.04 | Ubuntu 24.04+ | 说明 |
|------|--------------|---------------|------|
| linux/amd64 | ✅ 支持 | ✅ 支持 | x86-64 |
| linux/arm64 | ✅ 支持 | ✅ 支持 | ARM 64 位 |
| linux/armhf | ✅ 支持 | ✅ 支持 | ARM 32 位 v7 |
| linux/ppc64le | ✅ 支持 | ✅ 支持 | PowerPC 64 位 LE |
| linux/s390x | ✅ 支持 | ✅ 支持 | IBM System z |
| linux/riscv64 | ❌ 不可用 | ✅ 支持 | RISC-V 64 位 |

> **注意**：RISC-V（riscv64）支持从 Ubuntu 24.04 开始添加。

### 目录结构

```text
ubuntu/
├── docker/                      # Docker 配置
│   ├── 22/                      # Ubuntu 22.04（Jammy）
│   │   ├── Dockerfile           # 多阶段 Dockerfile
│   │   ├── docker-entrypoint.sh # 容器入口点
│   │   ├── vimrc.local          # Vim 配置
│   │   └── entrypoint.d/        # 模块化入口点脚本
│   ├── 24/                      # Ubuntu 24.04（Noble）
│   │   ├── Dockerfile           # 多阶段 Dockerfile
│   │   ├── docker-entrypoint.sh # 容器入口点
│   │   ├── vimrc.local          # Vim 配置
│   │   └── entrypoint.d/        # 模块化入口点脚本
│   ├── 25/                      # Ubuntu 25.10（Questing）
│   │   ├── Dockerfile           # 多阶段 Dockerfile
│   │   ├── docker-entrypoint.sh # 容器入口点
│   │   ├── vimrc.local          # Vim 配置
│   │   └── entrypoint.d/        # 模块化入口点脚本
│   ├── 26/                      # Ubuntu 26.04（Resolute）
│   │   ├── Dockerfile           # 多阶段 Dockerfile
│   │   ├── docker-entrypoint.sh # 容器入口点
│   │   ├── vimrc.local          # Vim 配置
│   │   └── entrypoint.d/        # 模块化入口点脚本
│   └── README.md                # Docker 文档
├── .github/workflows/           # CI/CD 流水线
│   ├── ci.yml                   # 持续集成
│   └── docker.yml               # Docker 构建和部署
└── docs/                        # 项目文档
```

## ⚙️ 配置

### 环境变量

| 变量 | 默认值 | 描述 |
|------|--------|------|
| `KEEPALIVE` | 0 | 保持容器运行（1=是，0=否）|
| `CAP_NET_BIND_SERVICE` | 0 | 启用绑定到特权端口（<1024）|
| `LANG` | C.UTF-8 | UTF-8 支持的区域设置 |
| `UMASK` | 022 | 文件创建掩码 |
| `DEBUG` | false | 在入口点脚本中启用调试输出 |
| `PASSWORDLESS_SUDO` | false | 为自定义用户启用无密码 sudo |
| `PGID` | 0 | 自定义用户的组 ID |
| `PUID` | 0 | 自定义用户的用户 ID |
| `USER` | root | 用户名（如果不是 root 则创建用户）|
| `WORKDIR` | /root | 工作目录 |
| `TZ` | - | 时区（例如：Asia/Shanghai）|

### 已安装的软件包

每个镜像都包含开发和运维的必要工具：

#### 系统工具

- bash、zsh、nano、rsync、lsb-release、procps、sudo、vim

#### 压缩工具

- zip、unzip、bzip2、xz-utils、gzip

#### 文件和数据工具

- file、jq

#### 时间和区域设置

- tzdata

#### 安全和证书

- openssl、gnupg、ca-certificates

#### 包管理

- aptitude

#### 系统监控

- sysstat

#### 网络工具

- wget、curl、git、dnsutils、netcat-traditional、traceroute、iputils-ping、net-tools、lsof

#### 容器工具

- libcap2-bin、gosu

#### 传输

- apt-transport-https

## 🔧 本地构建

### 前置要求

- Docker 20.10+ 或 Docker Desktop
- Docker Buildx（用于多架构构建）

### 构建命令

```bash
# 构建 Ubuntu 22.04
docker build -t ubuntu:22-local docker/22/

# 构建 Ubuntu 24.04
docker build -t ubuntu:24-local docker/24/

# 构建 Ubuntu 25.10
docker build -t ubuntu:25-local docker/25/

# 构建 Ubuntu 26.04
docker build -t ubuntu:26-local docker/26/

# 为特定平台构建
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ubuntu:24-local \
  docker/24/

# 为 Ubuntu 24.04+ 构建所有平台（需要 buildx）
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x,linux/riscv64 \
  -t ubuntu:24-multi \
  docker/24/

# 为 Ubuntu 22.04 构建所有平台（无 riscv64）
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/armhf,linux/ppc64le,linux/s390x \
  -t ubuntu:22-multi \
  docker/22/
```

## 📚 文档

- [Docker 配置指南](docker/README.md) - 详细的 docker 设置和使用
- [贡献指南](CONTRIBUTING.md) - 如何为此项目做贡献
- [更新日志](CHANGELOG.md) - 版本历史和发布说明
- [安全策略](SECURITY.md) - 安全报告和策略

## 🤝 贡献

欢迎贡献！请阅读我们的[贡献指南](CONTRIBUTING.md)了解详情：

- 行为准则
- 开发工作流程
- 提交消息约定
- 拉取请求流程

## 🔒 安全

安全是首要任务。如果您发现安全漏洞，请遵循我们的[安全策略](SECURITY.md)进行负责任的披露。

## 📄 许可证

本项目采用 **MIT 许可证**。
版权所有 (c) 2026-至今 [SnowdreamTech Inc.](https://github.com/snowdreamtech)
完整许可证文本请参见 [LICENSE](./LICENSE) 文件。

## 🙏 致谢

- 基于官方 [Ubuntu Docker 镜像](https://hub.docker.com/_/ubuntu)
- 受 Docker 社区最佳实践启发
- 使用 [GitHub Actions](https://github.com/features/actions) 构建

## 📞 支持

- 📧 邮箱：<sn0wdr1am@qq.com>
- 🐛 问题：[GitHub Issues](https://github.com/snowdreamtech/ubuntu/issues)
- 💬 讨论：[GitHub Discussions](https://github.com/snowdreamtech/ubuntu/discussions)

## Star 历史

[![Star History Chart](https://api.star-history.com/image?repos=snowdreamtech/ubuntu&type=date&legend=top-left)](https://www.star-history.com/?repos=snowdreamtech%2Fubuntu&type=date&legend=top-left)
