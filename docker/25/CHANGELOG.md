# Changelog

## [25.10.0](https://github.com/snowdreamtech/ubuntu/compare/25-v25.10.0...25-v25.10.0) (2026-08-28)


### 🐛 Bug Fixes

* **entrypoint:** unify default non-root username to appuser and restore flat script structure ([9c49bd8](https://github.com/snowdreamtech/ubuntu/commit/9c49bd84e65f27634296899cbc250b0f9636dfe0))
* **entrypoint:** wrap user setup in function and default username for non-root PUID ([93ffd60](https://github.com/snowdreamtech/ubuntu/commit/93ffd60173cce22a4f0c142ebd3839d0e87905c0))

## [25.10.0](https://github.com/snowdreamtech/ubuntu/compare/25-v25.10.0...25-v25.10.0) (2026-07-07)


### 🚀 Features

* **docker:** add Ubuntu 25.10 Dockerfile with OCI labels and essential packages ([c40635a](https://github.com/snowdreamtech/ubuntu/commit/c40635ae928a1abbf354f3bcd8e98ab91f61e80d))
* **docker:** create version folder structure for Ubuntu 22, 24, 25, 26 ([310760a](https://github.com/snowdreamtech/ubuntu/commit/310760af16c4b6e61db28e919267814b5ac1e53a))
* **scripts:** add Ubuntu 25.10 entrypoint scripts with modular initialization ([fad2150](https://github.com/snowdreamtech/ubuntu/commit/fad215064d4454dc907153ea16164d1c5b50974d))


### 🐛 Bug Fixes

* **docker:** add execute permissions to entrypoint scripts ([5418ebd](https://github.com/snowdreamtech/ubuntu/commit/5418ebd9ee1937039a9ac67baa1239679400b0f7))


### 🛠 Refactoring

* **docker:** align Dockerfile and entrypoint scripts with Debian standard ([f2ebe01](https://github.com/snowdreamtech/ubuntu/commit/f2ebe01a37d0d2084a2c1f100cfc94845a5c6a6e))
* **docker:** align Dockerfile and entrypoint scripts with Debian standard ([5b4f519](https://github.com/snowdreamtech/ubuntu/commit/5b4f5195c9e4348721875a990f4ae23e381f4da6))
* **docker:** align vimrc.local with Debian standard ([9c234d4](https://github.com/snowdreamtech/ubuntu/commit/9c234d4e2ddf2e9cd5a551852c8cbf636d696d93))
* **docker:** remove 99-base-end.sh to align with Debian standard ([4361742](https://github.com/snowdreamtech/ubuntu/commit/43617427fc9ad117d9999aa7d4e5e6822d963164))
* **docker:** translate vimrc.local comments to English ([d3d5961](https://github.com/snowdreamtech/ubuntu/commit/d3d5961d5c29b8213d73f038895b692250394616))


### ♻️ Miscellaneous Chores

* **docker:** add missing .dockerignore files to all versions ([81ae420](https://github.com/snowdreamtech/ubuntu/commit/81ae420f1adffb1036dd2dbb2a4a3fdbbb779d8e))
