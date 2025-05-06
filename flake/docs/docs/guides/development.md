# Development Workflow

This guide explains how to work with and contribute to this NixOS configuration.

## Development Environment

This repository includes a development environment with all the tools needed to work on the configuration.

### Prerequisites

- Nix with flakes enabled
- Git

### Setting Up Development Environment

Enter the development shell:

```bash
# From the repository root
nix develop
```

This provides a shell with all required tools, including:

- nix-unit for testing
- treefmt for code formatting
- pre-commit hooks
- direnv for environment management
- just for running common tasks

### Using just

The repository uses `just` as a command runner. To see all available commands:

```bash
just
```

Here are the most common development-related commands:

```bash
just reload     # Reload direnv
just check      # Run flake check
just fmt        # Format code with treefmt
just lint       # Run linting tools (deadnix)
just test       # Run tests
just pre-commit # Run pre-commit hooks
```

## Making Changes

### Workflow Overview

The typical workflow for making changes is:

1. Create a new branch
2. Make changes to relevant files
3. Test the changes
4. Format the code
5. Run linting and pre-commit hooks
6. Build and switch to the configuration
7. Commit the changes

### Modifying NixOS Modules

When working on NixOS modules:

1. Edit files in `modules/nixos/`
2. Test with `just test`
3. Apply changes with `just test-switch` or `just switch`

### Modifying Home Manager Modules

When working on Home Manager modules:

1. Edit files in `modules/home-manager/`
2. Test with `just test`
3. Apply changes with `just home-switch`

### Adding New Modules

To add a new module:

1. Create a new file in the appropriate directory
2. Follow the standard module structure
3. Import the module in the respective category's default.nix (if it exists)
4. Add tests if applicable
5. Document the module

Example of a new module:

```nix
# modules/nixos/category/new-module.nix
{ config, lib, ... }:

with lib;

let
  cfg = config.modules.category.new-module;
in
{
  options.modules.category.new-module = {
    enable = mkEnableOption "Enable new module";

    option1 = mkOption {
      type = types.str;
      default = "default value";
      description = "Description of option1";
    };
  };

  config = mkIf cfg.enable {
    # Implementation when enabled
  };
}
```

## Testing

### Running Tests

To run all tests:

```bash
just test
```

This will:

1. Run nix-unit tests
2. Check formatting
3. Run linting tools

### Writing Tests

Tests are located in `dev/tests/`. To add a new test:

1. Create a test file in `dev/tests/`
2. Define the test using nix-unit
3. Import the test in `dev/tests/default.nix`

Example test file:

```nix
# dev/tests/testNewModule.nix
{ pkgs, lib, ... }:

{
  name = "new-module-test";

  nodes.machine = { ... }: {
    modules.category.new-module.enable = true;
  };

  testScript = ''
    # Test script here
    machine.succeed("systemctl is-active some-service")
  '';
}
```

## Formatting and Linting

### Code Formatting

Format all code with:

```bash
just fmt
```

This uses treefmt to format Nix code according to the configuration in `dev/treefmt.nix`.

### Linting

Run linters with:

```bash
just lint
```

This runs deadnix to find dead code and other linting tools.

### Pre-commit Hooks

Run pre-commit hooks with:

```bash
just pre-commit
```

To install pre-commit hooks to run automatically:

```bash
pre-commit install
```

## Updating Flake Inputs

To update all flake inputs:

```bash
just update
```

To update specific inputs:

```bash
just update nixpkgs
```

## Building Different Outputs

### Testing Configuration

To test a configuration without applying it:

```bash
just test-switch
```

### Building ISO Images

To build an ISO image:

```bash
just iso image-name
```

### Building VM Images

To build a VM image:

```bash
just vm image-name
```

To run a VM for testing:

```bash
just run-vm hostname
```

## Managing Secrets

This configuration uses agenix for secrets management:

1. Add public keys to `hosts/secrets/identity/`
2. Create encrypted secrets with `agenix -e path/to/secret.age`
3. Rekey secrets when needed with `just rekey`

## Troubleshooting

### Common Issues

1. **Flake evaluation errors**:

   - Run `nix flake check --show-trace` for detailed error messages
   - Check for syntax errors in recently modified files

2. **Build failures**:

   - Look for specific error messages in the build output
   - Check that all dependencies are correctly specified

3. **Home Manager issues**:
   - Run `home-manager build --flake .#user@host` to test without applying
   - Check for conflicts in home-manager configurations

### Debugging Tools

1. **Tracing flake evaluation**:

   ```bash
   nix flake check --show-trace
   ```

2. **Inspecting flake outputs**:

   ```bash
   just inspect
   ```

3. **Viewing derivation information**:

   ```bash
   nix derivation show .#nixosConfigurations.hostname.config.system.build.toplevel
   ```

4. **Testing a specific module**:
   ```bash
   nix-instantiate --eval -E '(import <nixpkgs/nixos/lib/eval-config.nix> { modules = [ ./path/to/module.nix ]; }).config.option.path'
   ```
