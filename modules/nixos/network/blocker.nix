{
  config,
  lib,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib) mkEnableOption;

  cfg = config.modules.network.blocker;
in
{
  options.modules.network.blocker = {
    enable = mkEnableOption "StevenBlack hosts file blocking";
  };

  config = mkIf cfg.enable {
    networking.stevenblack = {
      enable = true;
      block = [
        "fakenews"
        "gambling"
        "porn"
      ];
    };
  };
}
