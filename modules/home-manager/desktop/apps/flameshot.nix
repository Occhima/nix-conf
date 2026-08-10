{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib isWayland;
in
{
  flake.modules.homeManager.flameshot =
    {
      config,
      lib,
      osConfig ? { },
      pkgs,
      ...
    }:
    let
      usingWayland = isWayland osConfig;

      flameShotPkg =
        if usingWayland then (pkgs.flameshot.override { enableWlrSupport = true; }) else pkgs.flameshot;
    in
    {
      config = lib.mkMerge [
        {
          services.flameshot = {
            enable = true;
            package = flameShotPkg;
            settings = {
              General = {
                # useGrimAdapter = usingWayland;
                # disabledGrimWarning = true;
                showStartupLaunchMessage = false;
                savePath = config.xdg.userDirs.extraConfig.SCREENSHOTS;
                savePathFixed = true;
                saveAsFileExtension = ".jpg";
                filenamePattern = "%F_%H-%M";
                drawThickness = 1;
                copyPathAfterSave = true;
              };
            };
          };

          wayland.windowManager.hyprland.settings =
            hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
              [
                {
                  key = "S";
                  dispatcher = "exec";
                  argument = "flameshot gui";
                  lua = hyprlandLib.luaExec "flameshot gui";
                }
              ];
        }
      ];
    };

  flake.modules.homeManager.niri =
    { config, lib, ... }:
    {
      # Keep Mod+S for Niri's native capture action from the grimblast feature.
      programs.niri.settings.binds."Mod+Shift+S" = lib.mkIf (config.services.flameshot.enable or false) {
        repeat = false;
        hotkey-overlay.title = "Open Flameshot";
        action.spawn = [
          "flameshot"
          "gui"
        ];
      };
    };
}
