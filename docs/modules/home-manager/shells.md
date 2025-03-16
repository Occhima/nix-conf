# Shell Modules

This documentation covers the shell configuration modules for Home Manager.

## Overview

The shell modules provide comprehensive configuration for your shell environment, including:

- Shell selection and configuration (Zsh)
- Command-line tools and utilities
- Shell prompts
- Predefined profiles for different workflows

## Available Modules

### Shell Type (zsh.nix)

The main shell module that configures your preferred shell.

#### Options

| Option            | Description                                | Default     |
|-------------------|--------------------------------------------|-------------|
| type              | The shell to use ("zsh", "bash", etc.)     | "zsh"       |

#### Usage

```nix
{ ... }:
{
  modules.shell = {
    type = "zsh";
  };
}
```

#### What It Does

When configured for Zsh, this module:

- Enables Zsh with proper configuration
- Sets up history, completion, and other Zsh features
- Configures key bindings and behavior
- Integrates with other shell modules

### CLI Tools

Command-line tools and utilities for enhanced productivity.

#### direnv.nix

Directory-specific environment manager.

```nix
{ ... }:
{
  modules.shell.cli.direnv = {
    enable = true;
  };
}
```

When enabled:
- Configures direnv to load .envrc files in directories
- Sets up shell hooks for proper integration
- Adds logging and helper functionality

#### pass.nix

Command line password manager.

```nix
{ ... }:
{
  modules.shell.cli.pass = {
    enable = true;
  };
}
```

When enabled:
- Installs pass and configures it
- Sets up proper integration with GPG
- Provides password management utilities

### Prompts

Shell prompt configurations for different styles and information.

#### starship.nix

Configures the Starship cross-shell prompt.

```nix
{ ... }:
{
  modules.shell.prompt = {
    type = "starship";
  };
}
```

When enabled:
- Installs and configures the Starship prompt
- Sets up modules and appearance
- Integrates with version control systems
- Displays relevant information like execution time, git status, etc.

### Profiles

Predefined collections of tools for specific workflows.

#### base.nix

Core utilities that should be available in most environments.

```nix
{ ... }:
{
  modules.shell.profiles.base.enable = true;
}
```

When enabled, installs common utilities like:
- `ripgrep` - Modern grep replacement
- `fd` - Modern find replacement
- `bat` - Cat replacement with syntax highlighting
- `exa` - Modern ls replacement
- And many other useful CLI tools

#### functional_programming.nix

Tools for functional programming languages.

```nix
{ ... }:
{
  modules.shell.profiles.functional_programming.enable = true;
}
```

When enabled, installs tools like:
- Haskell development tools
- Nix-related utilities
- Other functional programming languages support

#### sec.nix

Security-focused tools.

```nix
{ ... }:
{
  modules.shell.profiles.sec.enable = true;
}
```

When enabled, installs tools like:
- GnuPG
- Password managers
- Encryption utilities
- Security scanners

#### stats.nix

System monitoring and statistics tools.

```nix
{ ... }:
{
  modules.shell.profiles.stats.enable = true;
}
```

When enabled, installs tools like:
- `htop` - Interactive process viewer
- `neofetch` - System information tool
- Performance monitoring tools
- Disk usage analyzers

## Complete Example

Here's a comprehensive shell configuration example:

```nix
{ ... }:
{
  modules.shell = {
    type = "zsh";

    prompt = {
      type = "starship";
    };

    cli = {
      direnv.enable = true;
      pass.enable = true;
    };

    profiles = {
      base.enable = true;
      functional_programming.enable = true;
      sec.enable = true;
      stats.enable = true;
    };
  };
}
```

## Integration with Git

Your shell configuration integrates nicely with Git and other version control systems:

- Starship prompt shows git status
- Shell aliases for common git operations
- Tab completion for git commands
