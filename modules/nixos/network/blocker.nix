{ config, lib, ... }:

with lib;

let
  cfg = config.modules.networking.blocker;
in
{
  options.modules.networking.blocker = {
    enable = mkEnableOption "StevenBlack hosts file blocking";
  };

  config = mkIf cfg.enable {
    networking.stevenblack = {
      enable = true;
      block = [
        "fakenews"
        "gambling"
      ];
    };
  };
}
