{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    { config, ... }:
    let
      desktopCfg = config.modules.desktop;
      configType = config.wayland.windowManager.hyprland.configType;
    in
    {
      wayland.windowManager.hyprland.settings = hyprlandLib.mkBinds configType [
        {
          key = "Q";
          dispatcher = "exec";
          argument = desktopCfg.terminal.active;
          lua = hyprlandLib.luaExec desktopCfg.terminal.active;
        }
        {
          key = "K";
          dispatcher = "killactive";
          lua = "hl.dsp.window.close()";
        }
        {
          modifiers = [
            "SUPER"
            "SHIFT"
          ];
          key = "M";
          dispatcher = "exit";
          lua = "hl.dsp.exit()";
        }
        {
          modifiers = [
            "SUPER"
            "SHIFT"
          ];
          key = "R";
          dispatcher = "exec";
          argument = "hyprctl reload";
          lua = hyprlandLib.luaExec "hyprctl reload";
        }
        {
          key = "V";
          dispatcher = "togglefloating";
          lua = "hl.dsp.window.float({ action = \"toggle\" })";
        }
        {
          key = "F";
          dispatcher = "fullscreen";
          lua = "hl.dsp.window.fullscreen({ action = \"toggle\" })";
        }
        {
          key = "mouse:272";
          dispatcher = "movewindow";
          legacyFlags = "m";
          options.mouse = true;
          lua = "hl.dsp.window.drag()";
        }
        {
          key = "mouse:273";
          dispatcher = "resizewindow";
          legacyFlags = "m";
          options.mouse = true;
          lua = "hl.dsp.window.resize()";
        }
      ];
    };
}
