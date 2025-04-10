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
    font.name = "0xProto Nerd Font";
    themeFile = "Monokai_Soda";
  };
}
