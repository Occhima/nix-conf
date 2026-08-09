# Guernica theme root: importing `themes-guernica` activates the theme.
# The aspect is assembled from this file plus colors/config/fonts and every
# file under targets/ — all merging into the same deferred module.
{ config, ... }:
let
  themesStylix = config.flake.modules.homeManager.themes-stylix;
in
{
  flake.modules.homeManager.themes-guernica = {
    imports = [ themesStylix ];
  };
}
