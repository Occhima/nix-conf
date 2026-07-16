{ config, ... }:
let
  inherit (config.flake.lib.custom) themeLib;
  themes-stylix = config.flake.modules.homeManager.themes-stylix;
in
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      lib,
      ...
    }:
    let
      isGuernica = themeLib.isThemeActive config "guernica";
      isCompact = themeLib.isVariant config "compact";
      usingNiri = config.programs.niri.enable;
    in
    {
      imports = [ themes-stylix ];

      config = {
        modules.desktop.ui.themes = {
          name = lib.mkDefault "guernica";
          registry.guernica.meta = {
            name = "Guernica";
            description = "Dark theme with Polykai color scheme";
            variants = [
              "default"
              "compact"
            ];
            maintainer = "occhima";
          };
        };

        assertions = [
          {
            assertion = !(isGuernica && isCompact && usingNiri);
            message = "Compact variant is not supported for niri window manager yet.";
          }
        ];
      };
    };
}
