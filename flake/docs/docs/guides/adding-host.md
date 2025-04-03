# Adding a New Host

This guide explains how to add a new host (machine) to your NixOS configuration.

## Overview

The configuration is structured to make adding new hosts straightforward. Each host has its own directory with machine-specific settings, while inheriting shared modules and configurations.

## Steps to Add a New Host

### 1. Create Host Directory

Create a new directory for your host under the `hosts/` directory:

```bash
mkdir -p hosts/newhost
```

### 2. Create Basic Configuration Files

At minimum, you need a `default.nix` file for your host:

```bash
touch hosts/newhost/default.nix
```

Optionally, create additional configuration files:

```bash
# For hardware-specific configuration
touch hosts/newhost/hardware.nix

# For disk partitioning with disko
touch hosts/newhost/disko.nix
```

### 3. Configure Your Host

Edit the `default.nix` file with your host-specific configuration:

```nix
# hosts/newhost/default.nix
{ config, pkgs, lib, ... }:

{
  # Basic system configuration
  system.stateVersion = "24.11"; # Use the appropriate version

  # Host-specific settings
  networking.hostName = "newhost";

  # Hardware settings
  imports = [
    ./hardware.nix # If you created this file
  ];

  # Enable desired modules
  modules = {
    accounts = {
      enable = true;
      enabledUsers = [ "occhima" "root" ];
    };

    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      # Add other hardware modules as needed
    };

    network = {
      networkmanager.enable = true;
    };

    # Add other module categories as needed
  };

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    # Add packages specific to this host
  ];
}
```

If you created a hardware.nix file, configure it:

```nix
# hosts/newhost/hardware.nix
{ config, lib, pkgs, ... }:

{
  # Import hardware scan result if available
  # imports = [ (import ./hardware-configuration.nix) ];

  # Boot settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hardware-specific settings
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # Or for AMD:
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Other hardware settings as needed
}
```

If you created a disko.nix file, configure it for disk partitioning:

```nix
# hosts/newhost/disko.nix
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-path/device-path";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
```

### 4. Register Your Host in the Flake

Edit `hosts/flake-module.nix` to include your new host:

```nix
# Find the hosts section and add your new host
hosts = {
  # Existing hosts...

  newhost = {
    deployable = true; # or false if this isn't for remote deployment
    path = ./newhost;
    modules = [
      # Select appropriate profiles
      desktop  # For desktop systems
      # or
      headless # For servers
    ];
  };
};
```

### 5. Build and Test Your Configuration

Test your new host configuration:

```bash
just test-switch newhost
```

If everything looks good, switch to it:

```bash
just switch newhost
```

## Using Profiles

The configuration includes several profiles in `hosts/profiles/` that group common settings:

- **common/** - Settings shared by all hosts
- **desktop/** - Settings for desktop/laptop installations
- **headless/** - Settings for servers without a GUI
- **wsl/** - Settings for Windows Subsystem for Linux
- **iso/** - Settings for bootable ISO images

Include these profiles based on your host's purpose:

```nix
# In hosts/flake-module.nix
newhost = {
  path = ./newhost;
  modules = [
    desktop  # For a desktop/laptop system
    # or
    headless # For a headless server
  ];
};
```

## Adding Hardware Support

For specialized hardware, you can:

1. Create host-specific hardware configurations in your host directory
2. Use modules from `modules/nixos/hardware/` for common hardware
3. Leverage the nixos-hardware repository when appropriate:

```nix
# In your host's default.nix or hardware.nix
imports = [
  inputs.nixos-hardware.nixosModules.dell-xps-15-9500
  # Or other appropriate hardware modules
];
```

## Remote Deployment

To enable remote deployment for your host, add it to the `deploy.nix` file:

```nix
# In hosts/deploy.nix
nodes = {
  # Existing nodes...

  "newhost" = {
    hostname = "10.0.0.2"; # Replace with actual IP or hostname
    profiles.system = {
      user = "root";
      path = nixosConfigurations.newhost;
    };
  };
};
```

Then deploy using:

```bash
just install newhost
```
