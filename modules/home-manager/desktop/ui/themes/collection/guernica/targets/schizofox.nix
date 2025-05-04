{
  config,
  lib,
  ...
}:

let
  inherit (config.lib.stylix) colors;
  cfg = config.modules.desktop.ui.themes;

in
{
  programs.schizofox = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    extensions.simplefox.enable = true;
    theme = {
      colors = {
        background-darker = colors.base01;
        background = colors.base00;
        foreground = colors.base05;
      };
      font = config.stylix.fonts.monospace.name;
    };

  };
}
