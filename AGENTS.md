# Agent Instructions

This repository contains a NixOS configuration using flakes. Agents editing this repository must follow Nix best practices.

## Required Steps

3. Use `nix develop` to enter the development environment when working locally.
4. Keep inputs pinned using `nix flake lock` and update via `nix flake update` when needed.
5. Avoid imperative commands like `nix-env -i` or `nix-channel` updates. Prefer declarative configuration.
6. Structure Nix expressions using modules and avoid large monolithic files.
7. Reference [Nix Best Practices](https://nix.dev/guides/best-practices.html) for additional guidelines.
8. Read PROMPT.md for more information
