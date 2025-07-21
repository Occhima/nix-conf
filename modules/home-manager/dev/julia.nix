{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.dev.julia;
in
{
  options.modules.dev.julia = {
    enable = mkEnableOption "Enable Julia development tools";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.julia
    ];
  };
}
