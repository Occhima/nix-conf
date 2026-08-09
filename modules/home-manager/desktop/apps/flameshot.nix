{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib isWayland;
in
{
  flake.modules.homeManager.flameshot =
    {
      config,
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
      config = {
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

        programs.niri.settings.binds."Mod+S" = {
          repeat = false;
          hotkey-overlay.title = "Open Flameshot";
          action.spawn = [
            "flameshot"
            "gui"
          ];
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
      };
    };
}
