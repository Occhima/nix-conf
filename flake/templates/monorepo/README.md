# Monorepo Template

Data science monorepo with UV workspace, Python 3.12, Marimo notebooks, and Nix flake-parts.

## Structure

```
.
├── flake.nix              # Nix flake entry point
├── nix/                   # Nix configuration modules
│   ├── default.nix        # Module imports
│   ├── nix.nix            # Nix settings
│   ├── shell.nix          # Dev shell definition
│   └── modules/
│       ├── fmt.nix        # treefmt-nix configuration
│       └── pre-commit.nix # git-hooks configuration
└── coding/python/         # Python UV workspace
    ├── pyproject.toml     # Workspace root config
    └── src/
        ├── shared/        # Shared utilities
        └── core/          # Core business logic
```

## Getting Started

1. Enter development shell:

   ```bash
   nix develop
   ```

2. Dependencies will be synced automatically via `uv sync`.

3. Run marimo notebooks:
   ```bash
   marimo edit notebooks/example.py
   ```

## Tools Included

- **Python 3.12** with UV for dependency management
- **Marimo** for interactive notebooks
- **Ruff** for linting and formatting
- **Pre-commit hooks** with conventional commits
- **treefmt** for unified formatting
