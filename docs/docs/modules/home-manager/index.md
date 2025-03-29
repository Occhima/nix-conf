# Home Manager Modules

This directory contains reusable Home Manager modules that can be imported into your user configurations. These modules follow functional programming principles and provide a clear interface with options and implementation separated.

## Module Structure

Each module follows a standard structure:

```nix
{ config, lib, ... }:

let
  cfg = config.modules.<category>.<module-name>;
in
{
  options.modules.<category>.<module-name> = {
    enable = lib.mkEnableOption "Enable module name";
    # Other options...
  };

  config = lib.mkIf cfg.enable {
    # Implementation when enabled
  };
}
```

## Available Modules

### Data

Modules for user data management:

- **persistence.nix** - Persistence configuration with impermanence
- **xdg.nix** - XDG base directory specification

#### Usage Example

```nix
{ ... }:
{
  modules.data = {
    persistence = {
      enable = true;
      location = "persist";
      directories = [
        "Documents"
        "Downloads"
        "Pictures"
        # Other directories to persist
      ];
    };

    xdg.enable = true;
  };
}
```

For more details, see the [Data Modules](data.md) documentation.

### Desktop

Desktop environment configurations:

#### Apps

- **discord.nix** - Discord client configuration
- **flatpak.nix** - Flatpak integration
- **libreoffice.nix** - LibreOffice suite
- **thunar.nix** - Thunar file manager

#### Browser

- **nyxt.nix** - Nyxt browser configuration

#### Terminal

- **kitty.nix** - Kitty terminal emulator

#### Window Manager

- **themes/guernica/** - Guernica theme for window managers

#### Usage Example

```nix
{ ... }:
{
  modules.desktop = {
    apps = {
      discord.enable = true;
      flatpak.enable = true;
      libreoffice.enable = true;
    };

    terminal.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
    };
  };
}
```

### Shells

Shell configurations:

#### CLI Tools

- **direnv.nix** - Directory environment manager
- **pass.nix** - Password store

#### Prompts

- **starship.nix** - Starship prompt

#### Shell Configurations

- **zsh.nix** - Zsh configuration

#### Profiles

Shell profiles with predefined tools:

- **base.nix** - Base shell utilities
- **functional_programming.nix** - Tools for functional programming
- **sec.nix** - Security-related tools
- **stats.nix** - System monitoring tools

#### Usage Example

```nix
{ ... }:
{
  modules.shell = {
    type = "zsh";
    prompt.type = "starship";

    cli = {
      direnv.enable = true;
      pass.enable = true;
    };

    profiles = {
      base.enable = true;
      functional_programming.enable = true;
    };
  };
}
```

### Themes

Visual theme configurations:

- **guernica/** - Guernica theme

#### Usage Example

```nix
{ ... }:
{
  modules.themes.guernica = {
    enable = true;
    variant = "dark";
  };
}
```

## Integration with NixOS

These home-manager modules are integrated with NixOS in two ways:

1. **Via NixOS module** - Through the accounts module in modules/nixos/accounts/accounts.nix
2. **Standalone** - Through home/flake-module.nix for use outside of NixOS

For NixOS systems, you can enable home-manager modules by configuring your user in the host configuration:

```nix
{ ... }:
{
  modules.accounts = {
    enable = true;
    enabledUsers = [ "occhima" ];
    enableHomeManager = true;
  };
}
```

Then in your user configuration (`home/username/default.nix`):

```nix
{ config, ... }:
{
  home = {
    username = "occhima";
    homeDirectory = "/home/${config.home.username}";
  };

  modules = {
    shell = {
      type = "zsh";
      prompt.type = "starship";
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
    };

    # Other module configurations...
  };
}
```

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
