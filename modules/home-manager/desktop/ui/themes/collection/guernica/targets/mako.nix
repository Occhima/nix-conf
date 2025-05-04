{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;

in
{
  stylix.targets.mako.enable = mkIf (cfg.enable && cfg.name == "guernica") false;

  services.mako = mkIf (cfg.enable && cfg.name == "guernica") {
    font = config.stylix.fonts.monospace.name;
    anchor = "top-right";
    backgroundColor = "#000000FF";
    padding = "10";
    borderSize = 1;
    borderColor = "#9F9F9FFF";
    margin = "18";
    borderRadius = 10;
    maxIconSize = 52;
  };
}
