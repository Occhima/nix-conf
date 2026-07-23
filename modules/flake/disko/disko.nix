# Disko flake plumbing: the flake-parts module declaring the mergeable
# `flake.diskoConfigurations` output, plus the shared disko-base module
# every per-host layout (modules/flake/disko/) builds on.
{ config, inputs, ... }:
let
  face2face = config.flake.diskoConfigurations.face2face;
in
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.disko.flakeModule ];

  perSystem =
    { inputs', ... }:
    {
      apps = {
        disko = {
          type = "app";
          program = "${inputs'.disko.packages.disko}/bin/disko";
        };
        disko-install = {
          type = "app";
          program = "${inputs'.disko.packages.disko-install}/bin/disko-install";
        };
      };
    };

  flake.modules.nixos.disko-base =
    { lib, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      # Building the VM variant of any disko host (run-vm →
      # `system.build.vmWithDisko`) swaps in the face2face layout.
      virtualisation.vmVariantWithDisko.disko.devices = lib.mkForce face2face.devices;
    };
}
