# Vanilla Emacs package policy

The configuration is declared with `use-package`; Elpaca resolves and updates
ordinary Lisp packages asynchronously. Keep package recipes next to the module
that uses them instead of duplicating a manual inventory here.

Nix supplies Emacs itself, command-line dependencies, tree-sitter grammars, and
packages with native build steps (`eat`, `jinx`, `jupyter`, `mu4e`,
`pdf-tools`, and `vterm`). Their declarations use `:ensure nil` so Elpaca does
not rebuild them.

Elpaca stores mutable sources and builds below
`$XDG_DATA_HOME/emacs/elpaca`; caches and state use their corresponding XDG
directories. The Home Manager link at `$XDG_CONFIG_HOME/emacs` stays
declarative and read-only.
