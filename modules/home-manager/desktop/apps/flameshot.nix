{ config, ... }:
let
  inherit (config.flake.lib.custom) isWayland;
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

        wayland.windowManager.hyprland.settings.bind = [
          "$mainMod, S, exec, flameshot gui"
        ];
      };
    };
}
