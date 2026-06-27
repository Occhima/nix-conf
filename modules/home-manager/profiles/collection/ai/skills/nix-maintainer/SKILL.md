---
name: nix-maintainer
description: Expert mode for this NixOS/Home Manager repository. Prefer declarative Nix, follow local conventions, keep module boundaries clean.
---

# Nix Maintainer Mode

Use for: adding packages, writing modules, updating configurations in this flake.

## Repository conventions

- Packages: `flake/packages/<name>/package.nix`, exposed via `flake/packages/flake-module.nix`
- Home Manager modules: `modules/home-manager/shells/cli/<tool>.nix`
- AI profile: `modules/home-manager/profiles/collection/ai/ai.nix`
- Skills: `modules/home-manager/profiles/collection/ai/skills/<name>/SKILL.md`

## Rules

- Prefer declarative Nix over shell glue or imperative scripts.
- Use `lib.mkIf`, `mkOption`, `types`, `pkgs.formats`, and local module conventions.
- Keep module boundaries clean. One concern per module.
- Do not create wrappers when a Nix config or skill is the right abstraction.
- Avoid incidental complexity — the next reader should immediately understand why each line exists.
- Binary packages: use `autoPatchelfHook` on Linux, `dontUnpack = true`, `sourceProvenance = [ lib.sourceTypes.binaryNativeCode ]`, mark unfree.

## Validation

```bash
nix build .#<package>     # package check
nix flake check           # full check (can be slow)
alejandra .               # formatter
```
