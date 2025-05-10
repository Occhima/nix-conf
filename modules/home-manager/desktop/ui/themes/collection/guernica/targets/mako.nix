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
    settings = {
      font = config.stylix.fonts.monospace.name;
      anchor = "top-right";
      background-color = "#000000FF";
      padding = "10";
      border-size = 1;
      border-color = "#9F9F9FFF";
      margin = "18";
      border-radius = 10;
      max-icon-size = 52;
    };
  };
}
