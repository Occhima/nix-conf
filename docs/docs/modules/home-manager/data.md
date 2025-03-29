# Home Manager Data Modules

This documentation covers the data management modules for Home Manager.

## Overview

The data management modules help with:

- XDG directory configuration
- Data persistence across system rebuilds
- Dotfile management

## Available Modules

### XDG (xdg.nix)

The XDG module configures the XDG Base Directory Specification, which defines standard locations for user data, config, and cache files.

#### Options

| Option            | Description                                   | Default                    |
|-------------------|-----------------------------------------------|----------------------------|
| enable            | Whether to enable XDG directory configuration | false                      |

#### Usage

```nix
{ ... }:
{
  modules.data.xdg = {
    enable = true;
  };
}
```

#### What It Does

When enabled, this module:

- Sets up XDG base directories according to the specification
- Configures `~/.config`, `~/.local/share`, and `~/.cache` as the standard locations
- Enables proper management of user directories through home-manager

### Persistence (persistence.nix)

The persistence module manages state persistence across system rebuilds, particularly useful for NixOS systems with ephemeral root filesystems.

#### Options

| Option       | Description                                 | Default                                                                      |
|--------------|---------------------------------------------|------------------------------------------------------------------------------|
| enable       | Whether to enable persistence configuration | false                                                                        |
| location     | Subdirectory under $HOME for persisted data | "persist"                                                                    |
| directories  | Directories to persist                      | [ "Documents" "Downloads" "Pictures" "Videos" ".local/bin" ".ssh" ".local/share/nix" ] |

#### Usage

```nix
{ ... }:
{
  modules.data.persistence = {
    enable = true;
    location = "persist";
    directories = [
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"
      ".local/bin"
      ".ssh"
      # Add your custom directories here
    ];
  };
}
```

#### What It Does

When enabled, this module:

- Uses the impermanence module from nix-community
- Creates symlinks from the home directory to the persistence location
- Ensures important user data persists across system rebuilds
- Maintains a clean separation between ephemeral and persistent state

#### Requirements

This module requires the `impermanence` input in your flake configuration:

```nix
# In flake.nix
inputs = {
  # ...
  impermanence = {
    type = "github";
    owner = "nix-community";
    repo = "impermanence";
  };
  # ...
};
```

## Integration with System Configuration

These data modules work best when integrated with system-level persistence configuration:

```nix
# In your host configuration
{ ... }:
{
  modules.system.file-system.impermanence = {
    enable = true;
    persistentDirectories = [
      "/var/log"
      "/var/lib/bluetooth"
      # Other system directories to persist
    ];
  };
}
```

Then in your home-manager configuration:

```nix
{ ... }:
{
  modules.data = {
    persistence.enable = true;
    xdg.enable = true;
  };
}
```

## Best Practices

1. **Minimize Persistent Directories**: Only persist what's necessary to keep the benefits of an ephemeral root.
2. **Use Version Control**: For configurations that should be tracked, use home-manager's declarative approach rather than persisting them.
3. **Separate Code and Data**: Use persistence for user data, but manage configurations through Nix.
4. **XDG Compliance**: Encourage applications to follow XDG standards for cleaner home directories.
