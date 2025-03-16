# NixOS Modules

This directory contains reusable NixOS modules that can be imported into your host configurations. These modules follow functional programming principles and provide a clear interface with options and implementation separated.

## Module Structure

Each module follows a standard structure:

```nix
{ config, lib, ... }:

let
  cfg = config.modules.<module-name>;
in
{
  options.modules.<module-name> = {
    enable = lib.mkEnableOption "Enable module name";
    # Other options...
  };

  config = lib.mkIf cfg.enable {
    # Implementation when enabled
  };
}
```

## Available Modules

### Accounts

The accounts module provides user account management with home-manager integration:

- **accounts.nix** - Main module that manages users and integrates Home Manager
- **users/** - Individual user definitions

#### Usage

To use the accounts module in your configuration:

```nix
{ ... }:
{
  modules.accounts = {
    enable = true;
    enabledUsers = [ "occhima" "root" ];
    enableHomeManager = true;  # Set to false to disable home-manager integration
  };
}
```

### Hardware

Hardware-specific configurations:

- **audio.nix** - Audio configuration with PipeWire/PulseAudio
- **bluetooth.nix** - Bluetooth support
- **cpu/** - CPU-specific optimizations
- **gpu/** - Graphics drivers (NVIDIA, Intel, AMD)
- **monitors.nix** - Monitor configuration
- **ssd.nix** - SSD optimizations
- **yubikey.nix** - YubiKey support

#### Usage Example

```nix
{ ... }:
{
  modules.hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    gpu.nvidia.enable = true;  # For NVIDIA GPUs
    ssd.enable = true;
  };
}
```

### Network

Networking configurations:

- **blocker.nix** - Ad and tracker blocking
- **networkmanager.nix** - NetworkManager configuration
- **wireless.nix** - Wireless networking

#### Usage Example

```nix
{ ... }:
{
  modules.network = {
    networkmanager.enable = true;
    wireless.enable = true;
    blocker = {
      enable = true;
      blockLists = [ "StevenBlack" "someOtherList" ];
    };
  };
}
```

### Editor

Text editor configurations:

- **emacs.nix** - Emacs configuration
- **neovim.nix** - Neovim configuration

#### Usage Example

```nix
{ ... }:
{
  modules.editor = {
    neovim.enable = true;
    emacs = {
      enable = true;
      doom.enable = true;  # Enable Doom Emacs
    };
  };
}
```

### Secrets

Secret management:

- **agenix.nix** - Integration with agenix
- **agenix-rekey.nix** - Support for key rotation
- **ragenix.nix** - Enhanced agenix functionality
- **sops.nix** - Alternative using sops-nix

#### Usage Example

```nix
{ ... }:
{
  modules.secrets = {
    agenix = {
      enable = true;
      secrets = {
        example-secret = {
          file = ../secrets/vault/example.age;
          owner = "occhima";
          group = "users";
          mode = "0400";
        };
      };
    };
  };
}
```

### Security

Security-related configurations:

- **clamav.nix** - Antivirus scanning
- **kernel.nix** - Kernel hardening options

#### Usage Example

```nix
{ ... }:
{
  modules.security = {
    kernel = {
      enable = true;
      sysctl = {
        "kernel.unprivileged_bpf_disabled" = 1;
        # Other sysctl options...
      };
    };
    clamav.enable = true;
  };
}
```

### Services

System services:

- **systemd.nix** - Systemd configuration and optimizations
- **xserver.nix** - X server configuration

#### Usage Example

```nix
{ ... }:
{
  modules.services = {
    systemd = {
      enable = true;
      optimizeServices = true;
    };
  };
}
```

### System

Core system settings:

- **boot/** - Boot loader configurations
- **display/** - Display server configurations
- **file-system/** - File system configurations and persistence

#### Usage Example

```nix
{ ... }:
{
  modules.system = {
    boot = {
      generic.enable = true;
      loader.systemd.enable = true;
    };
    file-system = {
      impermanence = {
        enable = true;
        persistentDirectories = [
          "/var/log"
          "/var/lib/bluetooth"
          # Other directories to persist
        ];
      };
    };
  };
}
```

### Virtualization

Virtualization support:

- **distrobox.nix** - Distrobox container management
- **docker.nix** - Docker configuration
- **iso.nix** - ISO image creation
- **podman.nix** - Podman container runtime
- **qemu.nix** - QEMU/KVM virtualization
- **vm.nix** - Virtual machine configuration

#### Usage Example

```nix
{ ... }:
{
  modules.virtualization = {
    docker.enable = true;
    qemu = {
      enable = true;
      spiceSupport = true;
    };
  };
}
```

## Module Options

Each module exposes a set of options that can be configured. The basic pattern is:

```nix
modules.<category>.<module>.enable = true;
```

For more detailed options, refer to the documentation in each module file.

## Creating New Modules

To create a new module:

1. Create a new .nix file in the appropriate category directory
2. Follow the standard module structure (options/config pattern)
3. Import the module in the category's default.nix (if it exists)
4. Add documentation for the module

Example module template:

```nix
{ config, lib, ... }:

with lib;

let
  cfg = config.modules.category.module-name;
in
{
  options.modules.category.module-name = {
    enable = mkEnableOption "Description of the module";

    option1 = mkOption {
      type = types.str;
      default = "default value";
      description = "Description of option1";
    };

    # More options...
  };

  config = mkIf cfg.enable {
    # Implementation when the module is enabled
  };
}
```
