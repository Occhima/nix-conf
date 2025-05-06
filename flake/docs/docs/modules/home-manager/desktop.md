# Desktop Modules

This documentation covers the desktop environment modules for Home Manager.

## Overview

The desktop modules provide configuration for GUI applications and desktop environment components:

- Desktop applications (Discord, LibreOffice, etc.)
- File managers
- Web browsers
- Terminal emulators
- Window manager themes and configuration

## Available Modules

### Apps

Desktop application configurations:

#### discord.nix

Discord messaging application.

```nix
{ ... }:
{
  modules.desktop.apps.discord = {
    enable = true;
  };
}
```

When enabled:

- Installs Discord client
- Configures proper integration with desktop environment
- Sets up XDG paths for Discord data

#### flatpak.nix

Flatpak application management.

```nix
{ ... }:
{
  modules.desktop.apps.flatpak = {
    enable = true;
  };
}
```

When enabled:

- Installs Flatpak
- Configures system integration
- Sets up XDG portal support

#### libreoffice.nix

LibreOffice office suite.

```nix
{ ... }:
{
  modules.desktop.apps.libreoffice = {
    enable = true;
  };
}
```

When enabled:

- Installs LibreOffice
- Configures default themes and settings
- Sets up proper file associations

#### thunar.nix

Thunar file manager.

```nix
{ ... }:
{
  modules.desktop.apps.thunar = {
    enable = true;
  };
}
```

When enabled:

- Installs Thunar file manager
- Configures plugins and extensions
- Sets up file associations and default actions

### Browser

Web browser configurations:

#### nyxt.nix

Nyxt programmable web browser.

```nix
{ ... }:
{
  modules.desktop.browser.nyxt = {
    enable = true;
  };
}
```

When enabled:

- Installs Nyxt browser
- Configures with sensible defaults
- Sets up keybindings and behavior

### Terminal

Terminal emulator configurations:

#### kitty.nix

Kitty terminal emulator.

```nix
{ ... }:
{
  modules.desktop.terminal.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
  };
}
```

When enabled:

- Installs Kitty terminal
- Configures fonts, colors, and behavior
- Sets up keybindings and terminal features
- Integrates with shell configuration

### Window Manager

Window manager themes and configurations:

#### themes/guernica

Guernica theme for window managers.

```nix
{ ... }:
{
  modules.desktop.wm.themes.guernica = {
    enable = true;
  };
}
```

When enabled:

- Applies the Guernica theme to your window manager
- Configures matching Waybar theme
- Sets up coordinated color scheme across applications

## Complete Example

Here's a comprehensive desktop configuration example:

```nix
{ ... }:
{
  modules.desktop = {
    apps = {
      discord.enable = true;
      flatpak.enable = true;
      libreoffice.enable = true;
      thunar.enable = true;
    };

    browser.nyxt.enable = true;

    terminal.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
    };

    wm.themes.guernica = {
      enable = true;
    };
  };
}
```

## Integration with System

The desktop modules integrate with system-level configurations:

- Properly set up XDG desktop entries
- Configure desktop environment integration
- Use system theme settings where appropriate
- Handle file associations correctly

## Best Practices

1. **Selective Enabling**: Only enable the applications you actually use to keep your environment clean
2. **Consistent Theming**: Use a consistent theme across applications for a cohesive look
3. **Minimal Configuration**: Use the defaults unless you have a specific reason to change them
4. **Resource Consideration**: Be mindful of resource usage, especially with heavier applications
