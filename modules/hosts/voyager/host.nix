# Host: voyager — installer ISO image builder, not a real machine.
# Plain deferred NixOS module; usable without Den.
{ config, ... }: {
  flake.modules.nixos.host-voyager = {
    imports = [ config.flake.modules.nixos.iso-base ];

    networking.hostName = "voyager";
  };
}
