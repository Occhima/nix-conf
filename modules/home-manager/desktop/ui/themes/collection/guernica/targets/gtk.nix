{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  stylix.targets.gtk = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    enable = true;
    flatpakSupport.enable = true;
  };
}
