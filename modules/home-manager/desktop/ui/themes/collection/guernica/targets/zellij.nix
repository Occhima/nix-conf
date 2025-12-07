{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
  stylixColors = config.lib.stylix.colors;

  hexToRgb =
    hex:
    let
      r = lib.toInt ("0x" + builtins.substring 0 2 hex);
      g = lib.toInt ("0x" + builtins.substring 2 2 hex);
      b = lib.toInt ("0x" + builtins.substring 4 2 hex);
    in
    [
      r
      g
      b
    ];

  colors = with stylixColors; {
    bg = hexToRgb base00; # background
    bg-light = hexToRgb base01; # lighter background
    fg = hexToRgb base05; # foreground
    fg-dim = hexToRgb base03; # comments/dimmed

    red = hexToRgb base08;
    orange = hexToRgb base09;
    yellow = hexToRgb base0A;
    green = hexToRgb base0B;
    cyan = hexToRgb base0C;
    blue = hexToRgb base0D;
    magenta = hexToRgb base0E;
    purple = hexToRgb base0F;
  };

in
{
  stylix.targets.zellij.enable = themeLib.whenTheme config "guernica" false;

  programs.zellij = themeLib.whenTheme config "guernica" {
    settings = {
      theme = "polykai";

      simplified_ui = true;
      pane_frames = true;
      # Modern aesthetics
      ui = {
        pane_frames = {
          rounded_corners = true;
          hide_session_name = false;
        };
      };

      copy_command = "wl-copy";
      copy_clipboard = "primary";
      copy_on_select = false;

      scroll_buffer_size = 10000;
      scrollback_editor = config.home.sessionVariables.EDITOR;
      mouse_mode = true;

      session_serialization = false;
      pane_viewport_serialization = false;
      mirror_session = true;
      on_force_close = "detach";

    };

    themes.polykai = {
      fg = colors.fg;
      bg = colors.bg;
      black = colors.bg;
      red = colors.red;
      green = colors.green;
      yellow = colors.yellow;
      blue = colors.blue;
      magenta = colors.magenta;
      cyan = colors.cyan;
      white = colors.fg;
      orange = colors.orange;
    };
  };
}
