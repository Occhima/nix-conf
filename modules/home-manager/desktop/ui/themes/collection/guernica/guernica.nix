# Guernica theme root: importing `themes-guernica` activates the theme.
# The aspect is assembled from this file plus colors/config/fonts and every
# file under targets/ — all merging into the same deferred module.
{ config, ... }:
let
  inherit (config.flake.lib.custom) themeLib;
  themesStylix = config.flake.modules.homeManager.themes-stylix;
in
{
  flake.modules.homeManager.themes-guernica =
    {
      config,
      ...
    }:
    let
      isCompact = themeLib.isVariant config "compact";
      usingNiri = config.programs.niri.enable or false;
    in
    {
      imports = [ themesStylix ];

      config = {
        assertions = [
          {
            assertion = !(isCompact && usingNiri);
            message = "Compact variant is not supported for niri window manager yet.";
          }
        ];
      };
    };
}
