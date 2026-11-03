# NixOS Configuration

A fully **dendritic** NixOS + Home Manager configuration built on
[flake-parts](https://flake.parts) modules, [Den](https://den.denful.dev) hosts,
[import-tree](https://github.com/denful/import-tree) and
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
independent files contributing to the same name merge, and **importing
a module is what activates it**. Plain modules never import each other
for composition: all grouping, conditions and wiring happen in Den,
only in `modules/den/`. `hosts.nix`/`homes.nix` declare what exists
(`den.hosts`, `den.homes`), `defaults.nix` what applies everywhere, and
the aspects under `aspects/` import the plain feature modules. Den generates
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
├── den/         #   ALL composition: core, hosts, homes, defaults, integrations, aspects/
│   └── aspects/ #   hosts/, users/, themes/, home.nix, nixos.nix (groupings)
├── lib/         #   helpers merged into `flake.lib.custom` (an option, not a file import)
├── nixos/       #   NixOS feature modules (base, hardware, network, security, …)
│   ├── roles/   #   machine roles: graphical, headless, laptop, wsl
│   └── secrets/ #   agenix feature (flake glue + module) with its assets colocated
├── home-manager/#   Home Manager feature modules (shells, desktop, editors, …)
│   └── topics/  #   topic modules: ai, data, dev, finance, science, …
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

No `enable` option: a host whose aspect includes `bluetooth` has
bluetooth. The body is a plain NixOS module and the envelope is a plain
flake-parts option — no framework in sight. Plain modules never import
other plain modules for composition; grouping lives only in Den aspects.

### Split files, one module

All Hyprland fragments (`modules/home-manager/desktop/ui/window-manager/hyprland/config/…`)
independently contribute to `flake.modules.homeManager.hyprland`; the
module system merges them. The same goes for the Nixvim fragments under
`modules/flake/nixvim/` (→ `flake.nixvimModules.default`) and the Guernica
theme targets (→ `flake.modules.homeManager.themes-guernica`). Importing
`themes-guernica` carries the global theme (stylix, colours, fonts). Per-app
styling lives in plain `themes-guernica-<app>` modules (the "what"). The
Den aspect `den.aspects.guernica` (modules/den/aspects/themes/) decides the
"when": it has one child per app (`guernica.zen`, `guernica.calibre`, …),
each applying its module via `policy.when` only if the user also has that
app's aspect, and `includes = [ den.aspects.guernica._ ]` turns them all on.
The quickshell layout variant is chosen in the same aspect. A second theme
is another aspect with the same children.

### A host

```nix
# modules/den/aspects/hosts/steammachine/steammachine.nix
{ config, den, ... }:
{
  den.aspects.steammachine = {
    includes = [ den.aspects.gaming-workstation ];  # workstation + steam + oom + nix-ld
    nixos = {
      imports = with config.flake.modules.nixos; [
        cpu-amd gpu-nvidia login-regreet disko-steammachine pentesting-container
      ];
    };
  };
}
```

`modules/den/hosts.nix` declares the inventory and Den
generates `nixosConfigurations.steammachine`. `modules/den/defaults.nix`
applies `stateVersion` and the `define-user` and `hostname` batteries to
every host, user and home. Users get their `desktop` only on hosts that
include the `graphical` aspect (`policy.when` in the user aspect). Groupings (`system-base`,
`workstation`, `gaming-workstation`, `iso-base`) and roles (`graphical`,
`laptop`, `wsl`) are aspects in `modules/den/aspects/nixos.nix`; roles
are what other aspects test with `host.hasAspect`; Home Manager groupings (`shell`,
`desktop`, `editors`, `languages`, `personal-data`, `ai`, `cli-*`) are
aspects in `modules/den/aspects/home.nix`.

### A user

- `modules/den/aspects/users/occhima.nix` — the whole user: NixOS
  account (`nixos`), home identity and topic modules (`homeManager`) and
  the grouping aspects it runs (`includes`).
- `modules/den/aspects/users/root.nix` — `user-root`, included by
  `workstation`.
- `modules/den/hosts.nix` — `den.homes.x86_64-linux.occhima`
  generates `homeConfigurations.occhima` for non-NixOS machines from the
  same user aspect. **No fabricated `osConfig`**: modules that want host
  facts declare `osConfig ? { }` and degrade gracefully.

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
  contributing `flake.modules.nixos.<thing>`; add it to a host or
  grouping aspect under `modules/den/aspects/`. Done — import-tree discovers the file.
- **Add a Home Manager feature**: same shape,
  `flake.modules.homeManager.<thing>`.
- **Cross-context feature**: a plain `flake.modules.nixos.foo-host` and
  `flake.modules.homeManager.foo`, paired by one Den aspect
  (`den.aspects.foo = { nixos = …; homeManager = …; }`, see `hyprland`,
  `flatpak`, `podman` in `modules/den/aspects/home.nix`). A user that
  includes it gets both halves, so a home half without its system half
  cannot be written.
- **Add an input**: declare it via `flake-file.inputs.<name>` in the
  module that consumes it (only evaluation plumbing lives in
  `modules/flake/flake-file.nix`), then `nix run .#write-flake`
  regenerates flake.nix. Deleting the module drops its input on the next
  write-flake.
- **Add a host**: `modules/den/aspects/hosts/<name>/<name>.nix` (+
  `host.pub`) defining `den.aspects.<name>`, and an inventory entry in
  `modules/den/hosts.nix`. A `host.pub` next to it is enough
  for agenix-rekey: `modules/den/integrations/agenix-rekey.nix` sets
  `age.rekey.hostPubkey` and registers every host that has one.
- **Android (nix-on-droid)**: `den.hosts.aarch64-linux.phone` has class
  `nixOnDroid` and outputs `nixOnDroidConfigurations.phone`; its aspect
  (`modules/den/aspects/hosts/phone/`) imports `flake.modules.nixOnDroid.*`
  and the resolved `den.homes.aarch64-linux.phone-home`, so the phone
  reuses the same Home Manager aspects (`shell`, `editors`, …). On the
  phone: `nix-on-droid switch --flake <repo>#phone` (it evaluates with
  `--impure` by design).
- **Add a user**: `modules/den/aspects/users/<name>.nix` following
  occhima, plus entity entries as needed.
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
public key at `modules/den/aspects/hosts/<host>/host.pub`.

## References

- [Dendritic pattern](https://github.com/mightyiam/dendritic)
- [flake-parts `modules` option](https://flake.parts/options/flake-parts-modules.html)
- [import-tree](https://github.com/denful/import-tree)
- [flake-parts partitions](https://flake.parts/options/flake-parts-partitions.html)
