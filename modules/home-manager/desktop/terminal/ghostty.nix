{
  flake.modules.homeManager.terminal-ghostty = {
    config = {
      programs.ghostty = {
        enable = true;
        # Mirror kitty's defaults so switching terminals keeps the same look.
        settings = {
          font-size = 11;
          window-padding-x = 0;
          window-padding-y = 0;
          window-decoration = false;
          gtk-titlebar = false;
          gtk-tabs-location = "bottom";
          mouse-hide-while-typing = true;
          confirm-close-surface = false;
        };
      };
      home.sessionVariables.TERMINAL = "ghostty";
      modules.desktop.terminal.active = "ghostty";
    };
  };

  flake.modules.homeManager.niri =
    { config, lib, ... }:
    {
      programs.niri.settings.binds."Mod+Q" = lib.mkIf (config.programs.ghostty.enable or false) {
        repeat = false;
        hotkey-overlay.title = "Open Ghostty";
        action.spawn = "ghostty";
      };
    };
}
