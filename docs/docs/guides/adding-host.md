# Adding a New Host

A host is a Den aspect in `modules/den/aspects/hosts/<name>/<name>.nix`
plus an inventory entry. Plain feature modules stay untouched.

## 1. Declare the host

`modules/den/hosts.nix`:

```nix
den.hosts.x86_64-linux.myhost.users.occhima = { };
```

## 2. Create the host aspect

`modules/den/aspects/hosts/myhost/myhost.nix`:

```nix
{ config, den, ... }:
{
  den.aspects.myhost = {
    includes = with den.aspects; [ workstation laptop ]; # or gaming-workstation / system-base + wsl
    nixos = {
      imports = with config.flake.modules.nixos; [
        cpu-amd          # or cpu-intel
        gpu-nvidia       # or gpu-amd / gpu-intel
        login-greetd     # or login-regreet / login-silentsddm
        disko-myhost     # if it has a disko layout (see below)
      ];
      # hostname comes from the den.hosts entry (hostname battery)
      # genuine host data only: monitors, boot device, etc.
    };
  };
}
```

Den generates `nixosConfigurations.myhost`; import-tree discovers the file.

For a WSL host, declare `myhost.wsl.enable = true;` in the inventory (Den
imports NixOS-WSL and the `primary-user` battery sets `wsl.defaultUser`)
and include the `wsl` aspect.

## 3. Disko (optional)

Add `modules/flake/disko/myhost.nix` following the existing layouts. It
contributes `flake.diskoConfigurations.myhost` (for
`disko --flake .#myhost`) and the `disko-myhost` module the host imports.

## 4. Secrets (optional)

1. Put the host's SSH host public key at
   `modules/den/aspects/hosts/myhost/host.pub`.
   That's it: `modules/den/integrations/agenix-rekey.nix` sets
   `age.rekey.hostPubkey` and registers every host with a `host.pub`
   (`workstation` already includes `agenix`).

## 5. Build

```bash
nix build .#nixosConfigurations.myhost.config.system.build.toplevel
```
