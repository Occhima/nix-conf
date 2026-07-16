# NixOS Configuration

A fully **dendritic** NixOS + Home Manager configuration built on
[flake-parts](https://flake.parts), `flake.modules` (deferred modules) and
[import-tree](https://github.com/vic/import-tree).

## How it works

- Every `.nix` file under `modules/` is a top-level flake-parts module,
  discovered automatically — no manual import lists.
- A file contributes a named **aspect** to one or more classes:
  `flake.modules.nixos.<aspect>`, `flake.modules.homeManager.<aspect>`,
  `flake.modules.nixvim.default`, …
- Independent files contributing to the same aspect **merge** (Hyprland
  fragments, Nixvim fragments, theme targets).
- **Importing an aspect activates it.** There are no `modules.*.enable`
  switches, profile lists, or selector enums; options carry genuine data
  only (monitors, usernames, ports, device paths).
- Hosts and users are aspects too, and each host contributes its own
  `nixosConfigurations.<host>` output.

## Key features

- **Multi-host**: aerodynamic (laptop), beyond & steammachine (desktops),
  crescendoll (WSL), voyager (installer ISO)
- **Home Manager**: integrated per host and standalone
  (`homeConfigurations.occhima`)
- **Impermanence** + per-host **disko** layouts
- **Secrets** with agenix + agenix-rekey (per-host `host.pub`)
- **Dev partition**: formatters, pre-commit, tests, CI generation in
  `dev/` with a separate lock file

See the guides for recipes, and the repository README for the full
architecture walkthrough.
