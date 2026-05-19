{
  osConfig,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) concatMap;

  gamemode = pkgs.writeShellScriptBin "gamemode" ''
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
    if [ "$HYPRGAMEMODE" = 1 ] ; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword animation borderangle,0; \
            keyword decoration:shadow:enabled 0;\
            keyword decoration:blur:enabled 0;\
            keyword decoration:fullscreen_opacity 1;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"
        hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
    else
        hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
        hyprctl reload
    fi
  '';

  desktopCfg = config.modules.desktop;
  uiCfg = config.modules.desktop.ui;

  baseBind = [

    # Terminal
    "$mainMod, Q, exec, ${desktopCfg.terminal.active}"

    # Window management
    "$mainMod, F4, killactive,"

    "$mainMod SHIFT, M, exit,"
    "$mainMod SHIFT, R, exec, hyprctl reload"
    "$mainMod, V, togglefloating,"
    "$mainMod, J, togglesplit,"

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

  baseBindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  moduleBind = concatMap (entry: if entry.enable then entry.binds else [ ]) [
    {
      enable = uiCfg.launcher == "rofi";
      binds = [
        "$mainMod, SPACE, exec, rofi -show drun"
        "$mainMod, B, exec, rofi-bluetooth"
        "$mainMod, P, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
      ];
    }
    {
      enable = uiCfg.launcher == "anyrun";
      binds = [
        "$mainMod, SPACE, exec, anyrun"
      ];
    }
    {
      enable = desktopCfg.apps.flameshot.enable;
      binds = [
        "$mainMod, S, exec, flameshot gui"
      ];
    }
    {
      enable = desktopCfg.apps.wlogout.enable;
      binds = [

        "$mainMod, W, exec, wlogout"
      ];
    }
    {
      enable = uiCfg.locker == "hyprlock";
      binds = [
        "$mainMod, L, exec, hyprlock"
      ];
    }
    {
      enable = (config.modules.editor.emacs.enable && config.modules.editor.emacs.service);
      binds = [
        "$mainMod, E, exec, emacsclient -c"
      ];
    }
    {
      enable = (config.modules.services.clipboard.enable && uiCfg.launcher == "rofi");
      binds = [
        "$mainMod, K, exec, clipcat-menu --rofi-menu-length 10"
      ];
    }
    {
      enable = osConfig.modules.services.steam.enable;
      binds = [
        "$mainMod, G, exec, ${gamemode}/bin/gamemode"
      ];
    }

  ];
in
{
  config = {
    wayland.windowManager.hyprland.settings = {
      "$mainMod" = "SUPER";
      bind = baseBind ++ moduleBind;
      bindm = baseBindm;
    };
  };
}
