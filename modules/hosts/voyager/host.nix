# Host: voyager — ISO/installer.
# ponytail: minimal aspect, voyager is an ISO image builder not a real host.
{ config, inputs, ... }:
{
  flake.modules.nixos.voyager = {
    imports = with config.flake.modules.nixos; [
      iso-base
    ];
    config = {
      networking.hostName = "voyager";
    };
  };

  flake.nixosConfigurations.voyager = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ config.flake.modules.nixos.voyager ];
  };
}
