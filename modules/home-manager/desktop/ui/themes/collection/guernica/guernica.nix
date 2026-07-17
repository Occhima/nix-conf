# Guernica theme root: importing `themes-guernica` activates the theme.
# The aspect is assembled from this file plus colors/config/fonts and every
# file under targets/ — all merging into the same deferred module.
{ occhima, config, ... }:
let
  inherit (config.flake.lib.custom) themeLib;
in
{
  config.occhima.themes-guernica.includes = [ occhima.themes-stylix ];

  config.occhima.themes-guernica.homeManager =
    {
      config,
      ...
    }:
    let
      isCompact = themeLib.isVariant config "compact";
      usingNiri = config.programs.niri.enable or false;
    in
    {
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
