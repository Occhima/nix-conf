# NixOS Configuration

A modular, reproducible NixOS configuration built with **flake-parts** and
**Home Manager** — dendritic-inspired structural discovery on top,
conventional option-driven modules below.

<p align="center">
  <img alt="NixOS" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png" width="100"/>
</p>

[![NixOS](https://img.shields.io/badge/NixOS-flakes-blue?logo=NixOS&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/home--manager-integrated-blueviolet?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)

## Overview

- **One behavioral control plane** – every ordinary feature is enabled by
  setting its option (`modules.<area>.<thing>.enable = true;`), never by
  importing a module.
- **Automatic structural discovery** – flake modules, feature modules and
  hosts are picked up by convention; there are no central import lists or
  host registries to edit.
- **Typed host specifications** – each `hosts/<name>/default.nix` is a
  small data record (system, class, stateVersion, profiles, modules)
  validated by a typed schema and turned into a `nixosConfigurations`
  output by a small explicit builder.
- **Profiles as option presets** – `modules.profiles.active` selects
  coherent sets of feature options (desktop, laptop, graphical, wsl, …).
- **Impermanence, agenix secrets, disko, deploy-rs** integrations.

See [docs/docs/architecture.md](./docs/docs/architecture.md) for the full
design description.

## Directory Structure

```text
flake.nix             # inputs + a one-line mkFlake over modules/flake
justfile              # command runner (single source of truth)
modules/
├── flake/            # structural flake-parts modules (auto-discovered)
│   └── integrations/ # agenix, deploy-rs, disko, nixvim wiring
├── nixos/            # option-driven NixOS feature modules
│   └── profiles/     # NixOS option presets
├── iso/              # modules for the installer-image class
├── home-manager/     # option-driven Home Manager modules
│   └── profiles/     # Home Manager option presets
└── nixvim/           # nixvim configuration
hosts/                # typed host specifications (one dir per machine)
home/                 # per-user Home Manager configuration
packages/             # custom packages
templates/            # flake templates
overlays/             # overlay expressions
secrets/              # agenix vault + rekeyed secrets
lib/                  # custom helpers (lib.occhima) and discovery rules
dev/                  # development partition: checks, dev shell, tooling
docs/                 # mkdocs documentation
```

## Quick Start

```bash
git clone https://github.com/Occhima/nix-conf.git ~/.config/flake
cd ~/.config/flake
just switch
```

### Available Commands

This repository uses [just](https://github.com/casey/just) as a command
runner:

```bash
just              # List all available commands
just switch       # Switch to the new system configuration
just home-switch  # Apply the standalone home-manager configuration
just test-switch  # Test configuration without applying
just update       # Update flake inputs
just fmt          # Format code
just unit-tests   # Run nix-unit tests
just lint         # deadnix + statix
just iso voyager  # Build the installer ISO
just clean        # Clean the nix store
```

### Adding a New Host

1. Create `hosts/<name>/default.nix` returning a host specification:

   ```nix
   {
     system = "x86_64-linux";
     class = "nixos";
     stateVersion = "25.05";
     profiles = [ "desktop" "graphical" ];
     modules = [ ./configuration.nix ];
   }
   ```

2. Put the machine's option settings in `hosts/<name>/configuration.nix`.

That's it — there is no registry to update. See
[docs/docs/guides/adding-host.md](./docs/docs/guides/adding-host.md).

### Adding a New User

1. Create a user record in `modules/nixos/accounts/_users/`.
2. Add it to `allUsers` in `modules/nixos/accounts/accounts.nix`.
3. Create a Home Manager configuration in `home/<username>/`.
4. Add the user to `modules.accounts.enabledUsers` in the host config.

## Hosts

| Host         | Class | Description                        |
| ------------ | ----- | ---------------------------------- |
| aerodynamic  | nixos | Laptop (Intel/NVIDIA, graphical)   |
| steammachine | nixos | Desktop (AMD/NVIDIA, graphical)    |
| beyond       | nixos | Desktop (AMD/NVIDIA, graphical)    |
| crescendoll  | nixos | WSL development environment        |
| voyager      | iso   | Bootable installer image           |

## Development

```bash
nix develop        # dev shell (formatter, nix-unit, deploy-rs, …)
just unit-tests    # nix-unit tests, including the discovery contracts
just check         # nix flake check
```

Development-only inputs live in the `dev/` flake-parts partition, so host
evaluation never downloads them.

## Documentation

Full documentation lives in [docs/](./docs) and can be served with
`nix run .#docs`.

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
- [the dendritic pattern](https://github.com/mightyiam/dendritic)
