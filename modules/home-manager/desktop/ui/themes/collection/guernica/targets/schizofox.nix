{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
in
{
  programs.schizofox = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    extensions.simplefox = true;
    theme = {
      font = "Iosevka Nerd Font";
      background-darker = "181825";
      background = "1e1e2e";
      foreground = "cdd6f4";
    };
  };
}
