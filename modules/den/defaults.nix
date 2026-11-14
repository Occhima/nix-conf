{ lib, den, ... }:
{
  den.schema.user.classes = lib.mkDefault [
    "homeManager"
    "user"
  ];

  den.schema.host.includes = [ den.batteries.mutual-provider ];

  den.default = {
    nixos.system.stateVersion = "25.05";
    homeManager.home.stateVersion = "25.05";
  };
}
