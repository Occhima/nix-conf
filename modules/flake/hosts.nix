{
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  # Module-system lib for host evaluations: plain nixpkgs lib plus the
  # `occhima` namespace. The ordinary lib is never shadowed.
  hostLib = inputs.nixpkgs.lib.extend (_: _: { occhima = self.lib.occhima; });

  rootModule = {
    nixos = self.modules.nixos.default;
    iso = self.modules.nixos.iso;
  };

  mkHost =
    name: host:
    inputs.nixpkgs.lib.nixosSystem {
      lib = hostLib;

      # Only what module evaluation genuinely needs: flake inputs and the
      # flake itself (secrets, per-host assets and home directories are
      # looked up through `self`).
      specialArgs = { inherit inputs self; };

      modules =
        [
          rootModule.${host.class}
          {
            networking.hostName = lib.mkDefault name;
            nixpkgs.hostPlatform = lib.mkDefault host.system;
            nixpkgs.flake.source = inputs.nixpkgs.outPath;
          }
        ]
        ++ lib.optionals (host.class == "iso") [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
        ]
        ++ lib.optionals (host.class == "nixos") [
          {
            assertions = [
              {
                assertion = host.stateVersion != null;
                message = "occhima.hosts.${name}: a nixos host must pin its stateVersion";
              }
            ];
            system.stateVersion = host.stateVersion;
            modules.profiles = {
              enable = host.profiles != [ ];
              active = host.profiles;
            };
          }
        ]
        ++ host.modules;
    };
in
{
  occhima.hosts = self.lib.occhima.hostSpecsFromDir ../../hosts;

  flake.nixosConfigurations = lib.mapAttrs mkHost config.occhima.hosts;
}
