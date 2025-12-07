# stolen from: https://github.com/linuxmobile/kaku/blob/niri/home/software/wayland/niri/rules.nix
{
  lib,
  config,
  inputs,
  ...
}:

let
  inherit (lib) mkAfter;
  inherit (lib.custom) themeLib;
  themeEnabled = themeLib.isThemeActive config "guernica";
in

{
  imports = [
    inputs.niri.homeModules.stylix
  ];
  stylix.targets.niri.enable = themeEnabled;

  programs.niri = themeLib.whenTheme config "guernica" (mkAfter {
    settings = {
      overview = {
        workspace-shadow.enable = false;
        backdrop-color = "transparent";
      };
      layout = {
        focus-ring.enable = false;
        shadow = {
          enable = true;
        };
        preset-column-widths = [
          { proportion = 0.25; }
          { proportion = 0.5; }
          { proportion = 0.75; }
          { proportion = 1.0; }
        ];
        default-column-width = {
          proportion = 0.5;
        };

        gaps = 20;

        tab-indicator = {
          hide-when-single-tab = true;
          place-within-column = true;
          position = "left";
          corner-radius = 20.0;
          gap = -12.0;
          gaps-between-tabs = 10.0;
          width = 4.0;
          length.total-proportion = 0.1;
        };
      };

      layer-rules = [ ];
      window-rules = [ ];

    };
  });
}
