# NixOS Configuration

A fully **dendritic** NixOS + Home Manager configuration built on
[flake-parts](https://flake.parts) modules, [Den](https://den.denful.dev) hosts,
[import-tree](https://github.com/vic/import-tree) and
[flake-file](https://github.com/vic/flake-file).

<p align="center">
  <img alt="NixOS" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png" width="100"/>
</p>

[![NixOS](https://img.shields.io/badge/NixOS-flakes-blue?logo=NixOS&logoColor=white)](https://nixos.org)
[![Home Manager](https://img.shields.io/badge/home--manager-integrated-blueviolet?logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)

## The pattern in one paragraph

Every `.nix` file under `modules/` is a **top-level flake-parts module**,
discovered automatically by import-tree — no manual import lists, no
collectors, no aggregating `default.nix` files. Reusable features are
plain flake-parts **`flake.modules.<class>.<name>`** entries (no
framework vocabulary): a file contributes one coherent feature to a
class (`flake.modules.nixos.<name>`, `flake.modules.homeManager.<name>`),
independent files contributing to the same name merge, and composition
happens exclusively through `imports` — **importing a module is what
activates it**. Den appears only in `modules/den/`: hosts and users are
Den entities (`den.hosts`, `den.homes`) whose aspects import the plain
feature modules living outside the Den boundary, and Den generates
`nixosConfigurations`/`homeConfigurations` — nobody calls `nixosSystem`
by hand, and nothing reads a modules fixpoint. A flake check
(`checks.<system>.den-boundary`) fails if any `den.*` configuration shows
up outside `modules/den/`. Inputs are declared next
to the module that consumes them
([flake-file](https://github.com/vic/flake-file)); `flake.nix` is
generated with `nix run .#write-flake`. Options exist only for genuine
data (monitor layouts, usernames, ports, device paths).

```text
flake.nix        # inputs + two imports: flakeModules.modules, import-tree ./modules
modules/         # THE root configuration tree — every file is a flake-parts module
├── flake/       #   systems, per-system nixpkgs, flake-level glue (deploy-rs, …)
│   ├── _dev/    #   development partition: own flake + lock, skipped by import-tree
│   ├── disko/   #   disko glue + per-host layouts → diskoConfigurations outputs
│   └── nixvim/  #   nixvim glue + fragments merging into flake.nixvimModules.default
├── den/         #   THE Den boundary: core, aspects, entities (hosts/homes), integrations
├── lib/         #   helpers merged into `flake.lib.custom` (an option, not a file import)
├── hosts/       #   one dir per host: plain `flake.modules.nixos.host-<name>` module
├── users/       #   plain account (NixOS) and home (HM) user modules, Den-free
├── nixos/       #   NixOS feature modules (base, hardware, network, security, …)
│   └── secrets/ #   agenix feature (flake glue + module) with its assets colocated
├── home-manager/#   Home Manager feature modules (shells, desktop, editors, …)
│   └── profiles/#   aggregates: shell, desktop, editors, languages, personal-data, topic profiles
├── iso/         #   installer image modules
├── overlays/    #   one overlay contribution per file
├── packages/    #   package wiring; sources next door in _<name>/ (not discovered)
└── templates/   #   template outputs; the flakes live in _<name>/ subdirs
```

## How things compose

### A feature

```nix
# modules/nixos/hardware/bluetooth.nix
{ ... }:
{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      environment.systemPackages = [ pkgs.bluetui ];
    };
}
```

No `enable` option: a host that imports `bluetooth` has bluetooth. The
body is a plain NixOS module and the envelope is a plain flake-parts
option — no framework in sight.

### Split files, one module

All Hyprland fragments (`modules/home-manager/desktop/ui/window-manager/hyprland/config/…`)
independently contribute to `flake.modules.homeManager.hyprland`; the
module system merges them. The same goes for the Nixvim fragments under
`modules/flake/nixvim/` (→ `flake.nixvimModules.default`) and the Guernica
theme targets (→ `flake.modules.homeManager.themes-guernica`). Theme
styling for optional WMs/browsers (niri, schizofox, zen, spicetify,
caelestia) lives in explicit `themes-guernica-<app>` integration modules
under the same directory: importing an application module never activates
Guernica, and `homeManager.desktop` imports exactly the integrations it
needs.

### A host

```nix
# modules/hosts/steammachine/host.nix — a plain deferred NixOS module
{ config, ... }:
{
  flake.modules.nixos.host-steammachine = {
    imports = with config.flake.modules.nixos; [
      gaming-workstation # workstation + steam + oom + nix-ld
      cpu-amd gpu-nvidia login-ly disko-steammachine vpn-openvpn # identity
      pentesting-container
    ];
    modules.network.hostName = "steammachine"; # genuine data
    age.rekey.hostPubkey = builtins.readFile ./host.pub;
  };
}
```

The Den aspect in `modules/den/aspects/hosts/steammachine.nix` imports
exactly this module, and `modules/den/entities/hosts.nix` declares the
host inventory. Den generates `nixosConfigurations.steammachine` — no
manual `nixosSystem` call, no registry, and the plain host module works
without Den.

Variant choices are named modules (`cpu-amd`/`cpu-intel`, `gpu-nvidia`,
`login-ly`/`login-greetd`, `browser-zen-beta`, `terminal-kitty`), and
profiles are aggregate modules that just import other modules: the
`workstation` aggregate carries everything the physical machines share,
so a host lists only its identity (CPU/GPU, login manager, disko layout,
machine-specific services). Home Manager mirrors this: `shell`,
`desktop`, `editors`, `languages` and `personal-data` aggregates keep the
user environment short, next to the topic profiles (`ai`, `data`,
`science`, `pentesting`, …).

### A user

- `modules/users/occhima/home.nix` — `flake.modules.homeManager.user-occhima`:
  the plain Home Manager module (aggregate imports + home identity).
- `modules/users/occhima/account.nix` — `flake.modules.nixos.user-occhima`:
  the plain NixOS account. Both stay Den-free.
- `modules/den/aspects/users/occhima.nix` — the Den user aspect: its NixOS
  class imports `user-occhima` (NixOS), its Home Manager class imports
  `user-occhima` (HM). Nothing is duplicated.
- `modules/den/entities/homes.nix` — `den.homes.x86_64-linux.occhima`
  generates `homeConfigurations.occhima` for non-NixOS machines from the
  same user aspect, using the explicit internal overlay list. **No
  fabricated `osConfig`**: modules that want host facts declare
  `osConfig ? { }` and degrade gracefully.

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
  contributing `flake.modules.nixos.<thing>`; import it from a host or
  an aggregate. Done — import-tree discovers the file.
- **Add a Home Manager feature**: same shape,
  `flake.modules.homeManager.<thing>`.
- **Cross-context feature**: define both classes in one file
  (`flake.modules.nixos.foo` + `flake.modules.homeManager.foo`).
- **Add an input**: declare it via `flake-file.inputs.<name>` in the
  module that consumes it (only evaluation plumbing lives in
  `modules/flake/flake-file.nix`), then `nix run .#write-flake`
  regenerates flake.nix. Deleting the module drops its input on the next
  write-flake.
- **Add a host**: `modules/hosts/<name>/host.nix` as a plain
  `flake.modules.nixos.host-<name>` module (identity + short aggregate
  list + `host.pub`), an aspect in `modules/den/aspects/hosts/<name>.nix`
  importing it, and an inventory entry in `modules/den/entities/hosts.nix`.
  agenix-rekey hosts register in `modules/den/integrations/agenix-rekey.nix`.
- **Add a user**: `modules/users/<name>/` following the occhima files
  (plain NixOS account + plain HM module), plus a Den aspect in
  `modules/den/aspects/users/` and entity entries as needed.
- **Add a package**: expression in `modules/packages/_<name>/package.nix`
  (underscore = not discovered), wired by the sibling
  `modules/packages/<name>.nix` via `perSystem.packages.<name>` — the
  reference is a local `./_<name>/package.nix`, never a `../..` chain.
- **Add a disko layout**: `modules/flake/disko/<host>.nix` contributing
  `flake.diskoConfigurations.<host>` and the `disko-<host>` module.
- **Add a Nixvim tweak**: drop a file in `modules/flake/nixvim/` contributing to
  `flake.modules.nixvim.default`.

Files prefixed with `_` are **not** discovered by import-tree — that
prefix is reserved for non-module data files referenced lexically (e.g.
`_pentest-pkgs.nix`); never hide real configuration there.

## Hosts

| Host           | Role                                                           |
| -------------- | -------------------------------------------------------------- |
| `aerodynamic`  | laptop — Intel CPU, NVIDIA GPU, Greetd, disko + impermanence   |
| `beyond`       | desktop — AMD CPU, NVIDIA GPU, Ly, Steam, disko + impermanence |
| `steammachine` | desktop — AMD CPU, NVIDIA GPU, Ly, Steam, pentesting container |
| `crescendoll`  | WSL                                                            |
| `voyager`      | installer ISO                                                  |

## Development

```bash
just             # list commands (recipes rendered from modules/flake/_dev/just.nix)
just fmt         # format (treefmt: nixfmt, deadnix, shellcheck, prettier, …)
just test        # nix-unit tests
just check       # nix flake check
nix flake check --option allow-import-from-derivation false  # no-IFD gate
nix flake show   # inspect outputs
```

Generated files have one authoritative source each: `flake.nix` comes
from flake-file modules (`nix run .#write-flake`), `just-flake.just` from
`modules/flake/_dev/just.nix` (`nix build .#render-justfile -o
just-flake.just`), and `.github/workflows/*.yml` from
`modules/flake/_dev/actions.nix` (`nix run .#render-workflows`).
Freshness checks (`check-flake-file`, `justfile-fresh`,
`workflows-fresh`) fail on drift.

Development tooling (formatters, pre-commit, tests, CI workflow
generation) lives in the `modules/flake/_dev/` flake-parts **partition**
with its own lock file — the underscore keeps it out of import-tree, and
dev-only inputs never enter host evaluation.

`just test` runs two kinds of nix-unit suites: pure helper tests, and
**evaluation contract tests** that force the public outputs — every
host's `system.build.toplevel.drvPath` (voyager: ISO image), the
standalone home's `activationPackage.drvPath`, merged Hyprland/Nixvim
fragments, disko layouts, per-feature exports — to prove the composition
still holds. Nothing is built; drvPaths are the regression gate.

Every feature is also exported individually through
`modules.<class>.<name>` for external consumers — there is no
kitchen-sink module export.

## Secrets

Secrets live next to the agenix module that consumes them
(`modules/nixos/secrets/vault`), are rekeyed per host with
[agenix-rekey](https://github.com/oddlama/agenix-rekey) into
`modules/nixos/secrets/rekeyed/<host>`, and each host carries its own
public key at `modules/hosts/<host>/host.pub`.

## References

- [Dendritic pattern](https://github.com/mightyiam/dendritic)
- [flake-parts `modules` option](https://flake.parts/options/flake-parts-modules.html)
- [import-tree](https://github.com/vic/import-tree)
- [flake-parts partitions](https://flake.parts/options/flake-parts-partitions.html)
