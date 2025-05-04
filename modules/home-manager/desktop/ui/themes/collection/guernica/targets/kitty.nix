{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  # Disable stylix integration for kitty conditionally
  stylix.targets.kitty.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;

  # Override font and theme settings conditionally
  programs.kitty = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    font.name = config.stylix.fonts.monospace.name;
    themeFile = "Monokai_Soda";
  };
}
