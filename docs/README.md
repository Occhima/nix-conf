# NixOS Configuration Documentation

This directory contains the documentation for my NixOS configuration. The documentation is written in Markdown and is designed to be built with [MkDocs](https://www.mkdocs.org/) using the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme.

## Building the Documentation

To build and view the documentation locally:

1. Install MkDocs and the required plugins:

```bash
nix-shell -p 'python3.withPackages(ps: with ps; [ mkdocs mkdocs-material pymdown-extensions mkdocstrings ])'
```

2. Start the development server:

```bash
mkdocs serve
```

3. Open your browser to http://localhost:8000

## Documentation Structure

- `index.md`: Home page
- `guides/`: User guides for installation, adding hosts, etc.
- `modules/`: Documentation for NixOS and Home Manager modules

## Contributing to Documentation

When adding or modifying documentation:

1. Use Markdown for all documentation files
2. Follow the existing structure and style
3. Include examples and explanations for complex concepts
4. Update the navigation in `mkdocs.yml` if you add new pages
