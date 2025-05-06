# NixOS Configuration

A modular, reproducible NixOS configuration using flakes and home-manager.

## Overview

This repository contains a complete NixOS system configuration that follows modern best practices:

- Uses the Nix Flakes feature for reproducible builds and dependency management
- Employs a modular architecture to separate concerns and improve maintainability
- Integrates home-manager for user-level configuration management
- Supports multiple host configurations with shared modules
- Includes tools for secrets management, persistence, deployment, and testing

## Key Features

- **Modular Design**: System configuration split into logical, reusable components
- **Multi-Host Support**: Define multiple systems with shared configurations
- **Home Manager Integration**: User configurations managed alongside system configs
- **Impermanence**: Support for ephemeral root with persistent state
- **Secret Management**: Secure secrets handling with Agenix
- **Deployment Tools**: Remote deployment with deploy-rs
- **Development Environment**: Comprehensive dev tools and testing framework

## Directory Structure

| Directory          | Description                               |
| ------------------ | ----------------------------------------- |
| `flake.nix`        | Main flake entry point                    |
| `flake-module.nix` | Root flake module imported by flake.nix   |
| `hosts/`           | Host-specific configurations              |
| `home/`            | User home configurations via home-manager |
| `modules/`         | Shared NixOS and home-manager modules     |
| `packages/`        | Custom packages                           |
| `overlays/`        | Nixpkgs overlays                          |
| `lib/`             | Custom library functions                  |
| `dev/`             | Development tools and tests               |

## Quick Links

- [Installation Guide](guides/installation.md)
- [Adding a New Host](guides/adding-host.md)
- [Adding a New User](guides/adding-user.md)
- [NixOS Modules](modules/nixos/index.md)
- [Home Manager Modules](modules/home-manager/index.md)
- [Development Workflow](guides/development.md)
