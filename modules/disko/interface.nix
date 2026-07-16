# Disko integration: brings in the flake-parts module that declares the
# mergeable `flake.diskoConfigurations` output, plus the shared NixOS
# aspect every per-host disko aspect builds on.
{ config, inputs, ... }:
let
  face2face = config.flake.diskoConfigurations.face2face;
in
{
  imports = [ inputs.disko.flakeModule ];

  flake.modules.nixos.disko-base =
    { lib, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      # Building the VM variant of any disko host (run-vm →
      # `system.build.vmWithDisko`) swaps in the face2face layout.
      virtualisation.vmVariantWithDisko.disko.devices = lib.mkForce face2face.devices;
    };
}
