{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.c;
in
{
  options.modules.dev.c = {
    enable = mkEnableOption "Enable C development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
    ];

  };
}
