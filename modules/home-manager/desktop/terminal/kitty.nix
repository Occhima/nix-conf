{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.terminal.kitty;
in
{
  options.modules.desktop.terminal.kitty = {
    enable = mkEnableOption "Enable kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        mouse_hide_wait = "2.0";
        cursor_shape = "block";
        url_color = "#0087bd";
        url_style = "dotted";
        confirm_os_window_close = 0;
      };
    };
  };
}
