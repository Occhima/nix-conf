# NixOS Configuration

A modular, reproducible NixOS configuration built with **Flakes** and **Home Manager**.

<p align="center">
  <img alt="NixOS" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png" width="100"/>
</p>

[![NixOS](https://img.shields.io/badge/NixOS-flakes-blue?logo=NixOS&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/home--manager-integrated-blueviolet?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)
[![CI](https://img.shields.io/badge/CI-none-lightgrey)](#)

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Quick Start](#quick-start)
  - [Installation](#installation)
  - [Available Commands](#available-commands)
  - [Adding a New Host](#adding-a-new-host)
  - [Adding a New User](#adding-a-new-user)
- [Architecture](#architecture)
  - [Flake Structure](#flake-structure)
  - [Host Configuration](#host-configuration)
  - [Home Manager Integration](#home-manager-integration)
  - [Modules System](#modules-system)
  - [Secrets Management](#secrets-management)
  - [State Persistence](#state-persistence)
- [Development](#development)
  - [Development Environment](#development-environment)
  - [Testing](#testing)
  - [Code Formatting](#code-formatting)
  - [Pre-commit Hooks](#pre-commit-hooks)
- [Documentation](#documentation)
- [Roadmap](#roadmap)
- [References](#references)

## Overview

This repository contains a complete NixOS system configuration that follows modern best practices:

- **Modular Design** – system configuration split into logical, reusable components.
- **Multi-Host Support** – define multiple systems with shared configurations.
- **Home Manager Integration** – user configurations managed alongside system configs.
- **Impermanence** – support for ephemeral root with persistent state.
- **Secret Management** – secure secrets handling with Agenix.
- **Deployment Tools** – remote deployment with deploy-rs.
- **Development Environment** – comprehensive dev tools and testing framework.

## Directory Structure

```text
flake.nix          # Main flake entry point
flake-module.nix   # Root flake module imported by flake.nix
hosts/             # Host-specific configurations
home/              # User home configurations via home-manager
modules/           # Shared NixOS and home-manager modules
packages/          # Custom packages
overlays/          # Nixpkgs overlays
lib/               # Custom library functions
dev/               # Development tools and tests
```

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/occhima/nixos.git ~/.config/nixos

# Build and switch to the configuration for your host
cd ~/.config/nixos
just switch
```

### Available Commands

This repository uses [just](https://github.com/casey/just) as a command runner. Some key commands:

```bash
just             # List all available commands
just switch      # Switch to the new system configuration
just home-switch # Apply home-manager configuration
just test-switch # Test configuration without applying
just update      # Update flake lock file
just fmt         # Format code
just test        # Run tests
just clean       # Clean the nix store
```

### Adding a New Host

1. Create a new directory under `hosts/` for your host.
2. Add a `default.nix` file with the host-specific configuration.
3. Update `hosts/flake-module.nix` to include the new host in `hosts` attribute.
4. Configure deployment settings in `hosts/deploy.nix` if needed.

### Adding a New User

1. Create a user config file in `modules/nixos/accounts/users/`.
2. Add the user to `allUsers` in `modules/nixos/accounts/accounts.nix`.
3. Create a home-manager configuration in `home/username/`.
4. Enable the user by adding to `enabledUsers` in your host configuration.

## Architecture

### Flake Structure

This configuration uses [flake-parts](https://flake.parts/) to organize the flake into modular components:

- **flake.nix** – entry point with input definitions.
- **flake-module.nix** – root module that composes all components.
- Component flake modules:
  - `hosts/flake-module.nix`
  - `home/flake-module.nix`
  - `modules/flake-module.nix`
  - `overlays/flake-module.nix`
  - `packages/flake-module.nix`

### Host Configuration

Hosts are defined in `hosts/` with a structure that follows:

```text
hosts/
├── hostname/
│   ├── default.nix    # Main system configuration
│   ├── hardware.nix   # Hardware-specific settings
│   └── disko.nix      # Optional disk partitioning config
├── flake-module.nix   # Exports nixosConfigurations
├── deploy.nix         # Deployment configuration
└── profiles/          # Shared profiles for similar systems
    ├── common/        # Configurations shared by all hosts
    ├── desktop/       # Desktop-specific configurations
    ├── headless/      # Server configurations
    ├── iso/           # ISO image configurations
    └── wsl/           # Windows Subsystem for Linux configs
```

### Home Manager Integration

Home Manager is integrated in two ways:

1. **NixOS Module** – for users on NixOS systems via `modules/nixos/accounts/accounts.nix`.
2. **Standalone** – for users on non-NixOS systems via `home/flake-module.nix`.

Each user's configuration is stored in `home/username/`.

### Modules System

The `modules/` directory contains reusable configuration modules:

```text
modules/
├── flake-module.nix
├── nixos/                # System-level modules
│   ├── accounts/         # User account management
│   ├── hardware/         # Hardware-specific configs
│   ├── network/          # Networking configurations
│   ├── system/           # Core system settings
│   └── ...
└── home-manager/         # User-level modules
    ├── data/             # XDG and persistence
    ├── desktop/          # Desktop environment
    ├── shells/           # Shell configurations
    └── ...
```

### Secrets Management

This configuration uses [agenix](https://github.com/ryantm/agenix) for secrets management:

- Keys are stored in `hosts/secrets/identity/`.
- Encrypted secrets are in `hosts/secrets/vault/`.
- Rekey functionality via `agenix-rekey` facilitates key rotation.

### State Persistence

The configuration supports ephemeral root with persistent state via the [impermanence](https://github.com/nix-community/impermanence) module:

- System-level persistence in `modules/nixos/system/file-system/impermanence.nix`.
- User-level persistence in `modules/home-manager/data/persistence.nix`.

## Development

### Development Environment

```bash
# Enter development shell with all tools
nix develop

# Reload development environment
just reload
```

### Testing

```bash
just test         # Run all tests
nix run ./dev#test # Run Nix unit tests
```

### Code Formatting

```bash
just fmt
```

### Pre-commit Hooks

```bash
just pre-commit
```

## Documentation

Full documentation is available in the [docs directory](./flake/docs). The documentation covers installation, adding new hosts or users, module descriptions, and the development workflow. It can be built with MkDocs—see [flake/docs/README.md](./flake/docs/README.md) for instructions.

## Roadmap

- [ ] Create nix on droid configs
- [ ] Quickshell  as waybar
- [ ] Zen-Nebula theme not working
- [ ] fix guernica compact
- [ ] Niri window manager + new theme
- [ ] Dendritic patterna dn import-tree (https://github.com/vic/import-tree)

## References

This configuration was inspired by several excellent NixOS setups:

- [EmergentMind's nix-config](https://github.com/EmergentMind/nix-config/)
- [Edmund Miller's dotfiles](https://github.com/edmundmiller/dotfiles)
- [Remi Gelinas' rosetta](https://github.com/remi-gelinas/rosetta/)
- [Isabel Roses' dotfiles](https://github.com/isabelroses/dotfiles)
- [Montchr's dotfield](https://github.com/montchr/dotfield)
- [Henrik Lissner's dotfiles](https://github.com/hlissner/dotfiles)
- [MStream's nix-chad](https://github.com/mstream/nix-chad)
- [Misterio77's nix-config](https://github.com/Misterio77/nix-config)
