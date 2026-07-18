# Host: voyager — installer ISO image builder, not a real machine.
{ config, ... }:
{
  den.hosts.x86_64-linux.voyager = { };

  den.aspects.voyager = {
    nixos =
      { host, ... }:
      {
        imports = [ config.flake.modules.nixos.iso-base ];

        networking.hostName = host.hostName;
      };
  };
}
