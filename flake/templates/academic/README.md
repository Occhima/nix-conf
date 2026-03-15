# Academic Research Template

Academic research monorepo with UV workspace, LaTeX thesis, Python research packages, and Nix flake-parts.

## Structure

```
.
├── flake.nix                 # Nix flake entry point
├── nix/                      # Nix configuration modules
│   ├── default.nix           # Module imports
│   ├── nix.nix               # Nix settings
│   ├── shell.nix             # Dev shell with Python + LaTeX
│   └── modules/
│       ├── fmt.nix           # treefmt-nix configuration
│       └── pre-commit.nix    # git-hooks configuration
├── coding/python/            # Python UV workspace
│   ├── pyproject.toml        # Workspace root config
│   └── packages/
│       └── research/         # Research package
├── thesis/                   # LaTeX dissertation
│   ├── main.tex              # Main document
│   ├── references.bib        # Bibliography
│   └── Makefile              # Build automation
└── research/
    └── artifacts/            # Experiment outputs
```

## Getting Started

1. Enter development shell:

   ```bash
   nix develop
   ```

2. Dependencies will be synced automatically via `uv sync`.

3. Build thesis:

   ```bash
   cd thesis && make
   ```

4. Watch for changes:

   ```bash
   cd thesis && make watch
   ```

5. Run marimo notebooks:
   ```bash
   marimo edit notebooks/example.py
   ```

## Tools Included

- **Python 3.12** with UV for dependency management
- **LaTeX** with comprehensive academic packages
- **Marimo** for interactive notebooks
- **Pre-commit hooks** with conventional commits
- **treefmt** for unified formatting
