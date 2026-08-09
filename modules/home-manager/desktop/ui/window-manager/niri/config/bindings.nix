{
  flake.modules.homeManager.niri =
    {
      lib,
      ...
    }:
    let
      workspaceNumbers = lib.range 1 9;
      focusWorkspaces = lib.listToAttrs (
        map (number: {
          name = "Mod+${toString number}";
          value.action.focus-workspace = number;
        }) workspaceNumbers
      );
      moveToWorkspaces = lib.listToAttrs (
        map (number: {
          name = "Mod+Shift+${toString number}";
          value.action.move-column-to-workspace = [
            { focus = false; }
            number
          ];
        }) workspaceNumbers
      );
    in
    {
      # This aspect owns compositor mechanics only. Applications add their
      # bindings from their own dendritic modules.
      programs.niri.settings.binds = {
        "Mod+K" = {
          repeat = false;
          action.close-window = [ ];
        };
        "Mod+Shift+M" = {
          repeat = false;
          action.quit.skip-confirmation = true;
        };
        "Mod+Shift+R" = {
          repeat = false;
          action.load-config-file = [ ];
        };
        "Mod+V".action.toggle-window-floating = [ ];
        "Mod+F".action.fullscreen-window = [ ];
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = [ ];
        };
        "Mod+Shift+Slash" = {
          repeat = false;
          action.show-hotkey-overlay = [ ];
        };

        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+Ctrl+Left".action.move-column-left = [ ];
        "Mod+Ctrl+Right".action.move-column-right = [ ];
        "Mod+Ctrl+Up".action.move-window-up = [ ];
        "Mod+Ctrl+Down".action.move-window-down = [ ];

        "Mod+Shift+Left".action.focus-monitor-left = [ ];
        "Mod+Shift+Right".action.focus-monitor-right = [ ];
        "Mod+Shift+Up".action.focus-monitor-up = [ ];
        "Mod+Shift+Down".action.focus-monitor-down = [ ];
        "Mod+Ctrl+Shift+Left".action.move-column-to-monitor-left = [ ];
        "Mod+Ctrl+Shift+Right".action.move-column-to-monitor-right = [ ];
        "Mod+Ctrl+Shift+Up".action.move-column-to-monitor-up = [ ];
        "Mod+Ctrl+Shift+Down".action.move-column-to-monitor-down = [ ];

        "Mod+BracketLeft".action.focus-workspace-up = [ ];
        "Mod+BracketRight".action.focus-workspace-down = [ ];
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = [ ];
        };
        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = [ ];
        };
        "Mod+D".action.focus-monitor-next = [ ];
        "Mod+Shift+D".action.move-column-to-monitor-next = [ ];

        "Mod+T".action.toggle-column-tabbed-display = [ ];
        "Mod+Comma".action.consume-window-into-column = [ ];
        "Mod+Period".action.expel-window-from-column = [ ];
        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+C" = {
          repeat = false;
          hotkey-overlay.title = "Pick and copy a color";
          action.spawn-sh = ''
            color="$(niri msg pick-color | sed -n 's/^Hex: //p')"
            [ -n "$color" ] && printf '%s' "$color" | wl-copy
          '';
        };
        "Mod+Ctrl+C".action.center-visible-columns = [ ];
        "Mod+Tab".action.switch-focus-between-floating-and-tiling = [ ];
      }
      // focusWorkspaces
      // moveToWorkspaces;
    };
}
