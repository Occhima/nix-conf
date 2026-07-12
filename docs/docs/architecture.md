# Architecture

This configuration is **dendritic-inspired at the structural level and
option-driven at the behavioral level**. Structure (which modules exist,
which hosts exist, which outputs are published) is discovered
automatically; behavior (which features a machine actually runs) is
selected exclusively through typed options.

```text
flake modules (modules/flake)
    │
    ├── register root NixOS module
    ├── register root Home Manager module
    ├── load typed host specs
    └── construct flake outputs

root modules
    │
    └── automatically import option-driven feature modules

profiles
    │
    └── configure feature options

hosts
    │
    └── select profiles and provide machine-specific modules
```

The directory contract:

```text
modules/flake         = structural top-level (flake-parts) modules
modules/nixos         = option-driven NixOS modules
modules/iso           = option-driven modules for the iso class
modules/home-manager  = option-driven Home Manager modules
modules/nixvim        = nixvim configuration modules
.../profiles          = option presets
hosts                 = typed machine specifications
home                  = per-user Home Manager configuration
packages              = packages
templates             = flake templates
overlays              = overlay expressions
secrets               = agenix vault and rekeyed secrets
dev                   = development partition (checks, shells, tooling)
lib                   = the `lib.occhima` helper namespace
```

## The three discovery boundaries

Each boundary has its own loader and its own contract. They are
deliberately not one generic mechanism.

### 1. Structural modules — `modules/flake/`

Every `*.nix` file under `modules/flake/` is a flake-parts module,
imported by the loader in `modules/flake/default.nix`:

- every `*.nix` file is imported recursively;
- `default.nix` files are never imported (the loader is the only one);
- `_`-prefixed files and directories are skipped.

These modules declare top-level schema (`occhima.hosts`), register the
root modules, build `nixosConfigurations`, and wire external flake
modules (agenix-rekey, disko, nixvim, deploy-rs). They contain no
machine-specific behavior.

### 2. Feature modules — `modules/nixos/`, `modules/iso/`, `modules/home-manager/`

Conventional option-pattern modules, collected per class by
`lib.occhima.nixModulesFromDir` (see `lib/discovery.nix`):

- every `*.nix` file is imported;
- a directory containing a `default.nix` is imported through that
  `default.nix` and not recursed into — the `default.nix` wires its own
  subtree;
- `_`-prefixed files and directories are private (data files, per-host
  disko layouts, user records) and never imported.

The collected trees are published as root modules in
`modules/flake/modules.nix`:

- `self.modules.nixos.default` — all NixOS feature options
- `self.modules.nixos.iso` — the installer-image class
- `self.modules.homeManager.default` — all Home Manager feature options

The historical names (`self.nixosModules.{default,common,nixos,iso}`,
`self.homeModules.default`) remain as compatibility aliases pointing at
the same root modules; remove them once nothing references them.

### 3. Host specifications — `hosts/<name>/default.nix`

Each immediate `hosts/<name>/` directory with a `default.nix` is a host.
The `default.nix` returns **data**, not a module:

```nix
{
  system = "x86_64-linux";
  class = "nixos"; # or "iso"
  stateVersion = "25.05";
  deployable = false;

  profiles = [
    "laptop"
    "graphical"
  ];

  modules = [ ./configuration.nix ];
}
```

The schema is typed (`options.occhima.hosts` in
`modules/flake/schema.nix`) and the builder in `modules/flake/hosts.nix`
turns each spec into a `nixosConfigurations` entry with
`nixpkgs.lib.nixosSystem`:

- the class root module is imported (`nixos` or `iso`);
- `networking.hostName` defaults to the directory name;
- `system.stateVersion` comes from the spec (there is no global
  default — never upgrade it for an existing installation);
- `modules.profiles.active` is set from `profiles`;
- `specialArgs` carries only `inputs` and `self`;
- the module-system `lib` is nixpkgs' lib extended with the `occhima`
  namespace — the ordinary `lib` is never shadowed.

## One behavioral control plane

**There is exactly one public mechanism for enabling an ordinary
feature: configure its option.**

```nix
modules.virtualisation.podman.enable = true;
```

Feature modules are auto-imported and therefore always _available_, but
never _active_ until enabled. Do not enable features by importing named
modules — imports are structural registration, not behavioral selection.
Two activation paths for the same feature would mean two sources of
truth for what a machine runs.

The only modules meant to be imported wholesale are the class roots
(`modules.nixos.default`, `modules.nixos.iso`,
`modules.homeManager.default`), because they _are_ the composition, not
a feature.

## Profiles

Profiles are option presets, not import lists. The active set is typed:

```nix
modules.profiles.active = [ "desktop" "graphical" ];
```

A profile module guards on membership and sets feature options:

```nix
{ config, lib, ... }:
{
  config = lib.mkIf (lib.occhima.hasProfile config [ "graphical" ]) {
    modules.hardware.media.sound.enable = true;
    modules.services.flatpak.enable = true;
  };
}
```

NixOS profiles live in `modules/nixos/profiles/` (enum in
`options.nix`: desktop, laptop, headless, graphical, wsl); Home Manager
profiles in `modules/home-manager/profiles/`. An invalid profile name
fails evaluation via the enum type.

## Home Manager

- **Integrated (primary)**: `modules/nixos/accounts/accounts.nix` wires
  `home-manager.users.<name>` from `home/<name>/` and shares
  `self.modules.homeManager.default`.
- **Standalone**: `homeConfigurations.occhima`
  (`modules/flake/home-manager.nix`) for non-NixOS machines.

Shared HM modules never reach into arbitrary `osConfig` paths. Host
facts are consumed through the typed `modules.hostContext` options
(`modules/home-manager/host-context.nix`): when integrated, its defaults
derive from the real `osConfig`; standalone, the context is set
explicitly next to the standalone configuration. There is no fake NixOS
configuration anywhere.

## How to…

### add a NixOS feature

Create `modules/nixos/<area>/thing.nix` with the option pattern:

```nix
{ config, lib, ... }:
let
  cfg = config.modules.<area>.thing;
in
{
  options.modules.<area>.thing.enable = lib.mkEnableOption "thing";
  config = lib.mkIf cfg.enable { ... };
}
```

It is discovered automatically; enable it from a host, a profile, or
another module with `modules.<area>.thing.enable = true;`.

### add a Home Manager feature

Same pattern under `modules/home-manager/`. If it needs host facts, read
`config.modules.hostContext.*`.

### add a profile

Add the name to the enum in `modules/{nixos,home-manager}/profiles/options.nix`
and create a module under the profiles tree guarded by
`lib.occhima.hasProfile config [ "<name>" ]`.

### add a host

```bash
mkdir hosts/newhost
$EDITOR hosts/newhost/default.nix   # the spec shown above
$EDITOR hosts/newhost/configuration.nix
```

No registry to edit — `nixosConfigurations.newhost` appears on the next
evaluation. Machine data (hardware config, `assets/host.pub` for agenix)
lives in the host directory.

## Why dendritic-inspired, not fully dendritic

The fully dendritic pattern makes _every_ Nix file a top-level
flake-parts module. This repository borrows the good part — automatic,
convention-driven composition with no central import lists — but keeps
conceptual distinctions the dendritic pattern erases:

- a **host** is a domain object (data), not a reusable feature module;
- a **package** is a package expression, not a module;
- an **asset** (disko layout, user record, QML config, secret) is data;
- a **feature** is an option-pattern module, activated by options.

Flattening those into one namespace would trade explicit structure for
uniformity and would recreate the two-control-plane problem this
architecture exists to avoid.
