# Host: voyager — installer ISO image builder, not a real machine.
{ config, ... }:
{
  den.hosts.x86_64-linux.voyager = { };

  den.aspects.voyager = {
    nixos = {
      imports = [ config.flake.modules.nixos.iso-base ];

      networking.hostName = "voyager";
    };
  };
}
