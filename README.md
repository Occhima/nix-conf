# NixOS Configuration

A fully **dendritic** NixOS + Home Manager configuration built on
[flake-parts](https://flake.parts), `flake.modules` (deferred modules), and
[import-tree](https://github.com/vic/import-tree).

<p align="center">
  <img alt="NixOS" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png" width="100"/>
</p>

[![NixOS](https://img.shields.io/badge/NixOS-flakes-blue?logo=NixOS&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/home--manager-integrated-blueviolet?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)

## The pattern in one paragraph

Every `.nix` file under `modules/` is a **top-level flake-parts module**,
discovered automatically by import-tree — there are no manual import lists,
no recursive collectors, and no `default.nix` files whose job is to
enumerate siblings. A file contributes one coherent *feature* (an
"aspect") to one or more module classes via
`flake.modules.<class>.<aspect>`. Independent files may contribute to the
*same* aspect and their definitions merge. Composition happens by
importing aspects from the fixed point (`config.flake.modules.*`) —
**importing an aspect is what activates it**. There are no
`modules.<x>.enable` switches, profile string lists, or implementation
selector enums; options exist only for genuine data (monitor layouts,
usernames, ports, device paths).

```text
flake.nix        # inputs + two imports: flakeModules.modules, import-tree ./modules
modules/         # THE root configuration tree — every file is a flake-parts module
├── flake/       #   systems, per-system nixpkgs, per-aspect module exports
│   └── _dev/    #   development partition: own flake + lock, skipped by import-tree
├── lib/         #   helpers merged into `flake.lib.custom` (an option, not a file import)
├── hosts/       #   one dir per host: aspect + its own nixosConfigurations output
├── users/       #   account aspects (NixOS) + home aspects (HM) + standalone HM output
├── nixos/       #   NixOS feature aspects (base, hardware, network, security, …)
│   └── secrets/ #   agenix feature (flake glue + aspect) with its assets colocated
├── home-manager/#   Home Manager feature aspects (shells, desktop, editors, …)
│   └── profiles/#   aggregates: shell, desktop, editors, languages, data-core, topic profiles
├── iso/         #   installer image aspects
├── nixvim/      #   fragments merging into flake.modules.nixvim.default + its flake glue
├── disko/       #   per-host disko layouts + diskoConfigurations outputs
├── overlays/    #   one overlay contribution per file
├── packages/    #   package wiring; sources next door in _<name>/ (not discovered)
├── templates/   #   template outputs; the flakes live in _<name>/ subdirs
└── integrations/#   agenix-rekey, deploy-rs, nixvim glue
```

## How things compose

### A feature (aspect)

```nix
# modules/nixos/hardware/bluetooth.nix
{ ... }:
{
  config.flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      environment.systemPackages = [ pkgs.bluetui ];
    };
}
```

No `enable` option: a host that imports `bluetooth` has bluetooth.

### Split files, one aspect

All Hyprland fragments (`modules/home-manager/desktop/ui/window-manager/hyprland/config/…`)
independently contribute to `flake.modules.homeManager.hyprland`; the
module system merges them. The same goes for the Nixvim fragments under
`modules/nixvim/` (→ `flake.modules.nixvim.default`) and the Guernica
theme targets (→ `flake.modules.homeManager.themes-guernica`).

### A host

```nix
# modules/hosts/steammachine/host.nix
{ config, inputs, ... }:
{
  flake.modules.nixos.steammachine = {
    imports = with config.flake.modules.nixos; [
      workstation # aggregate: everything the physical machines share
      cpu-amd gpu-nvidia login-ly disko-steammachine steam # …
    ];
    config = {
      modules.network.hostName = "steammachine";  # genuine data
      age.rekey.hostPubkey = builtins.readFile ./host.pub;
    };
  };

  # The host contributes its own flake output — no central host registry.
  flake.nixosConfigurations.steammachine = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config.flake.modules.nixos.steammachine ];
  };
}
```

Variant choices are named aspects (`cpu-amd`/`cpu-intel`, `gpu-nvidia`,
`login-ly`/`login-greetd`, `browser-zen-beta`, `terminal-kitty`), and
profiles are aggregate aspects that just import other aspects: the
`workstation` aggregate carries everything the physical machines share,
so a host lists only its identity (CPU/GPU, login manager, disko layout,
machine-specific services). Home Manager mirrors this: `shell`,
`desktop`, `editors`, `languages` and `data-core` aggregates keep the
user environment short, next to the topic profiles (`ai`, `data`,
`science`, `pentesting`, …).

### A user

- `modules/users/occhima/account.nix` — NixOS aspect `user-occhima`:
  creates the account and wires `home-manager.users.occhima` to the HM
  aspect.
- `modules/users/occhima/home.nix` — HM aspect `occhima`: the user
  environment, a short list of aggregates plus topic profiles.
- `modules/users/occhima/standalone.nix` — `homeConfigurations.occhima`
  for non-NixOS machines. There is **no fabricated `osConfig`**: modules
  that want host facts declare `osConfig ? { }` and degrade gracefully.

### Helpers

Shared functions merge into an option, not a file you import by relative
path:

```nix
# contribute:  flake.lib.custom.isWayland = …;   (modules/lib/predicates.nix)
# consume:
{ config, ... }:
let inherit (config.flake.lib.custom) isWayland; in …
```

## Recipes

- **Add a NixOS feature**: create `modules/nixos/<area>/<thing>.nix`
  contributing `flake.modules.nixos.<thing>`; import it from a host or an
  aggregate aspect. Done — import-tree discovers the file.
- **Add a Home Manager feature**: same shape under
  `modules/home-manager/`, class `homeManager`.
- **Cross-context feature**: define both classes in *one* file
  (`flake.modules.nixos.foo` + `flake.modules.homeManager.foo`).
- **Add a host**: `modules/hosts/<name>/host.nix` defining the host
  aspect *and* its `flake.nixosConfigurations.<name>` output (plus
  `host.pub` + a `perSystem.agenix-rekey` registration if it uses
  secrets).
- **Add a user**: `modules/users/<name>/{account,home}.nix` following the
  occhima files.
- **Add a package**: expression in `modules/packages/_<name>/package.nix`
  (underscore = not discovered), wired by the sibling
  `modules/packages/<name>.nix` via `perSystem.packages.<name>` — the
  reference is a local `./_<name>/package.nix`, never a `../..` chain.
- **Add a disko layout**: `modules/disko/<host>.nix` contributing
  `flake.diskoConfigurations.<host>` and the `disko-<host>` aspect.
- **Add a Nixvim tweak**: drop a file in `modules/nixvim/` contributing to
  `flake.modules.nixvim.default`.

Files prefixed with `_` are **not** discovered by import-tree — that
prefix is reserved for non-module data files referenced lexically (e.g.
`_pentest-pkgs.nix`); never hide real configuration there.

## Hosts

| Host | Role |
| --- | --- |
| `aerodynamic` | laptop — Intel CPU, NVIDIA GPU, Greetd, disko + impermanence |
| `beyond` | desktop — AMD CPU, NVIDIA GPU, Ly, Steam, disko + impermanence |
| `steammachine` | desktop — AMD CPU, NVIDIA GPU, Ly, Steam, pentesting container |
| `crescendoll` | WSL |
| `voyager` | installer ISO |

## Development

```bash
just             # list commands
just fmt         # format (treefmt via the dev partition)
just unit-tests  # nix-unit tests
just check       # nix flake check
nix flake show   # inspect outputs
```

Development tooling (formatters, pre-commit, tests, CI workflow
generation) lives in the `modules/flake/_dev/` flake-parts **partition**
with its own lock file — the underscore keeps it out of import-tree, and
dev-only inputs never enter host evaluation.

`just unit-tests` runs two kinds of nix-unit suites: pure helper tests,
and **evaluation contract tests** that force the public outputs (every
host's toplevel, the standalone home, merged Hyprland/Nixvim fragments,
disko layouts, per-aspect exports) to prove the composition still holds.

Every aspect is also exported individually as `nixosModules.<aspect>` /
`homeModules.<aspect>` for external consumers — there is no kitchen-sink
module export.

## Secrets

Secrets live next to the agenix aspect that consumes them
(`modules/nixos/secrets/vault`), are rekeyed per host with
[agenix-rekey](https://github.com/oddlama/agenix-rekey) into
`modules/nixos/secrets/rekeyed/<host>`, and each host carries its own
public key at `modules/hosts/<host>/host.pub`.

## References

- [Dendritic pattern](https://github.com/mightyiam/dendritic)
- [flake-parts `modules` option](https://flake.parts/options/flake-parts-modules.html)
- [import-tree](https://github.com/vic/import-tree)
- [flake-parts partitions](https://flake.parts/options/flake-parts-partitions.html)
