# Adding a New User

This guide explains how to add a new user to your NixOS configuration with Home Manager integration.

## Overview

The configuration manages users in two ways:

1. **System Users**: Defined in `modules/nixos/accounts/users/`
2. **Home Manager Configurations**: Defined in `home/username/`

## Steps to Add a New User

### 1. Create User Definition

Create a new file for the user in `modules/nixos/accounts/users/`:

```bash
touch modules/nixos/accounts/users/newuser.nix
```

Edit the file with the user's system-level configuration:

```nix
# modules/nixos/accounts/users/newuser.nix
{
  initialPassword = "changeme";
  isNormalUser = true;

  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample/Key/Here"
  ];

  extraGroups = [
    "networkmanager"
    "systemd-journal"
    "audio"
    "video"
    "input"
    "wheel" # For sudo access
  ];
}
```

### 2. Register the User in Accounts Module

Edit `modules/nixos/accounts/accounts.nix` to add the user to the `allUsers` attribute:

```nix
# Find the allUsers definition and add your new user
allUsers = {
  occhima = import ./users/occhima.nix;
  root = import ./users/root.nix;
  newuser = import ./users/newuser.nix; # Add this line
};
```

### 3. Create Home Manager Configuration

Create a directory for the user's home configuration:

```bash
mkdir -p home/newuser
touch home/newuser/default.nix
```

Edit the file with the user's home configuration:

```nix
# home/newuser/default.nix
{ config, ... }:
{
  home = {
    username = "newuser";
    homeDirectory = "/home/${config.home.username}";
  };

  # Enable desired modules
  modules = {
    shell = {
      type = "zsh";
      prompt.type = "starship";
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
    };

    # Add other modules as needed
  };
}
```

### 4. Enable the User in Host Configuration

Edit your host configuration to enable the user:

```nix
# hosts/hostname/default.nix
{ ... }:
{
  # Find or add the accounts module configuration
  modules.accounts = {
    enable = true;
    enabledUsers = [
      "root"
      "occhima"
      "newuser" # Add this line
    ];
    enableHomeManager = true;
  };
}
```

### 5. Build and Apply Configuration

Apply the changes to your system:

```bash
just switch
```

## Home Manager Standalone Configuration

If you want to use Home Manager standalone (not as part of NixOS), you can use the configurations directly:

```bash
# Apply configuration for a specific user@host
home-manager switch --flake .#newuser@hostname
```

Or use the convenience command:

```bash
just home-switch hostname
```

## User Configuration Options

### Shell Configuration

Configure the user's shell:

```nix
modules.shell = {
  type = "zsh"; # Or "bash", "fish", etc.
  prompt.type = "starship"; # Prompt configuration

  cli = {
    direnv.enable = true;
    pass.enable = true;
  };

  profiles = {
    base.enable = true;
    functional_programming.enable = true;
  };
};
```

### Desktop Environment

Configure desktop components:

```nix
modules.desktop = {
  apps = {
    discord.enable = true;
    flatpak.enable = true;
    libreoffice.enable = true;
  };

  terminal.kitty.enable = true;

  # Window manager, themes, etc.
};
```

### Data Management

Configure XDG directories and persistence:

```nix
modules.data = {
  xdg.enable = true;

  persistence = {
    enable = true;
    location = "persist";
    directories = [
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"
      ".ssh"
      # Other directories to persist
    ];
  };
};
```

## Migrating an Existing User

If you're migrating an existing user to this configuration:

1. Create the user definition and home configuration as described above
2. Make sure to back up any important files before applying changes
3. Consider using the persistence module to maintain important data

## Testing User Configuration

You can test a user's home configuration without applying it:

```bash
home-manager build --flake .#newuser@hostname
```

This builds the configuration and shows what would be changed, without actually applying the changes.
