{ lib, ... }:
{
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.default = {
    nixos.system.stateVersion = "25.05";
    homeManager.home.stateVersion = "25.05";
  };
}
