# Disko flake plumbing: the flake-parts module declaring the mergeable
# `flake.diskoConfigurations` output, plus the shared disko-base aspect
# every per-host layout (modules/flake/disko/) builds on.
{ config, inputs, ... }:
let
  face2face = config.flake.diskoConfigurations.face2face;
in
{
  imports = [ inputs.disko.flakeModule ];

  occhima.disko-base.nixos =
    { lib, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      # Building the VM variant of any disko host (run-vm →
      # `system.build.vmWithDisko`) swaps in the face2face layout.
      virtualisation.vmVariantWithDisko.disko.devices = lib.mkForce face2face.devices;
    };
}
