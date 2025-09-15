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
  # Disable stylix integration for kitty conditionally
  stylix.targets.kitty.enable = mkIf (cfg.enable && cfg.name == "guernica") false;

  # Override font and theme settings conditionally
  programs.kitty = mkIf (cfg.enable && cfg.name == "guernica") {
    font.name = config.stylix.fonts.monospace.name;
    themeFile = "Monokai_Soda";
  };
}
