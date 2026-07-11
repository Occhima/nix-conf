# Adding a New Host

Hosts are **typed specifications**, not modules. Adding a machine takes a
directory and two files; there is no registry to edit.

## 1. Create the host directory

```bash
mkdir -p hosts/newhost
```

## 2. Write the specification

`hosts/newhost/default.nix` returns data validated against
`options.occhima.hosts` (see `modules/flake/schema.nix`):

```nix
{
  system = "x86_64-linux";
  class = "nixos"; # or "iso" for installer images
  stateVersion = "25.05"; # pin once, never upgrade in place

  # Option presets; names are validated against the profile enum.
  profiles = [
    "desktop"
    "graphical"
  ];

  # Machine-specific modules only. Reusable features are enabled
  # through options inside them, never imported here.
  modules = [ ./configuration.nix ];
}
```

## 3. Configure the machine

`hosts/newhost/configuration.nix` is an ordinary NixOS module that sets
feature options:

```nix
{
  modules = {
    accounts = {
      enable = true;
      enabledUsers = [
        "occhima"
        "root"
      ];
    };

    hardware.cpu.type = "amd";
    hardware.gpu.type = "nvidia";

    system.boot.loader.type = "grub";
    services.ssh.enable = true;
  };
}
```

Every option under `modules.*` is already available — the root module
imports the whole feature tree automatically.

## 4. Machine data

- `hosts/newhost/assets/host.pub` — host key, required when
  `modules.secrets.agenix.enable = true` (rekey with `just rekey`).
- Disko layout: add
  `modules/nixos/system/file-system/_partitions/newhost.nix` and set
  `modules.system.file-system.disko.enable = true`.

## 5. Build it

```bash
nix build .#nixosConfigurations.newhost.config.system.build.toplevel
just classic-install newhost   # or: just partition-install / deploy
```

`networking.hostName` defaults to the directory name;
`system.stateVersion` comes from the spec.
