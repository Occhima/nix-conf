{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  stylix.targets.kitty.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;

  programs.ghostty = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    settings = {
      font-family = config.stylix.fonts.monospace.name;
      cursor-style-blink = true;
      cursor-style = "block";
      font-feature = "+liga";
    };
  };
}
