{ ... }:
{
  flake.modules.homeManager.terminal-kitty = {
    config = {
      programs.kitty = {
        enable = true;
        settings = {
          bold_font = "auto";
          italic_font = "auto";
          bold_italic_font = "auto";
          mouse_hide_wait = "2.0";
          cursor_shape = "block";
          confirm_os_window_close = 0;
        };
      };
      home.sessionVariables.TERMINAL = "kitty";
      modules.desktop.terminal.active = "kitty";
    };
  };
}
