{
  config,
  ...
}:
let
  desktopCfg = config.modules.desktop;
in
{
  config = {
    wayland.windowManager.hyprland.settings = {
      "$mainMod" = "SUPER";
      bind = [
        # Terminal
        "$mainMod, Q, exec, ${desktopCfg.terminal.active}"

        # Window management
        "$mainMod, K, killactive,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod SHIFT, R, exec, hyprctl reload"
        "$mainMod, V, togglefloating,"
        "$mainMod, J, layoutmsg, togglesplit"

        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, F, fullscreen"

        # Workspace number binds live in workspaces.nix (native) or
        # plugins/{hyprsplit,split-monitor-workspaces}.nix.

        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
