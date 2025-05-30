{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.clipboard;
in
{
  options.modules.services.clipboard = {
    enable = mkEnableOption "CopyQ clipboard manager";
  };

  config = mkIf cfg.enable {
    services.clipcat = {
      enable = true;
      enableSystemdUnit = true;
    };
  };
}
