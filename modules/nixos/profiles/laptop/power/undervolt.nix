{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "laptop" ]) {
    services.undervolt = {
      enable = config.modules.hardware.cpu.type == "intel";
      tempBat = 65;
      package = pkgs.undervolt;
    };
  };
}
