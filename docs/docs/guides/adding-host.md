# Adding a New Host

A host is one directory under `modules/hosts/<name>/` containing a single
discovered module that defines the host **aspect** and the host **output**.

## 1. Create the host module

`modules/hosts/myhost/host.nix`:

```nix
{ config, inputs, ... }:
{
  flake.modules.nixos.myhost = {
    imports = with config.flake.modules.nixos; [
      system-base
      accounts
      user-occhima
      user-root
      # pick hardware/variant aspects:
      cpu-amd            # or cpu-intel
      gpu-nvidia         # or gpu-amd / gpu-intel
      login-ly           # or login-greetd / login-sddm
      disko-myhost       # if it has a disko layout (see below)
      graphical
      desktop            # or laptop / headless aggregates
    ];
    config = {
      modules.network.hostName = "myhost";
      # genuine host data only: monitors, boot device, etc.
    };
  };

  flake.nixosConfigurations.myhost = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config.flake.modules.nixos.myhost ];
  };
}
```

That's it — import-tree discovers the file; no registry to update.

## 2. Disko (optional)

Add `modules/flake/disko/myhost.nix` following the existing layouts. It
contributes `flake.diskoConfigurations.myhost` (for
`disko --flake .#myhost`) and the `disko-myhost` aspect the host imports.

## 3. Secrets (optional)

If the host uses agenix secrets:

1. Put the host's SSH host public key at `modules/hosts/myhost/host.pub`.
2. In the host aspect: `age.rekey.hostPubkey = builtins.readFile ./host.pub;`
   and import the `agenix` aspect.
3. Register for rekeying in the same file:

```nix
  perSystem = _: {
    agenix-rekey.nixosConfigurations.myhost = config.flake.nixosConfigurations.myhost;
  };
```

## 4. Build

```bash
nix build .#nixosConfigurations.myhost.config.system.build.toplevel
```
