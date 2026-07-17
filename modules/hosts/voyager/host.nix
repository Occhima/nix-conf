# Host: voyager — installer ISO image builder, not a real machine.
{ occhima, ... }:
{
  den.hosts.x86_64-linux.voyager = { };

  den.aspects.voyager = {
    includes = with occhima; [
      iso-base
    ];

    nixos = {
      networking.hostName = "voyager";
    };
  };
}
