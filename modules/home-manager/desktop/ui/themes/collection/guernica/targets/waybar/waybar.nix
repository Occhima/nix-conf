# Guernica waybar target: disables the stylix waybar styling and applies
# the theme's own variant-aware configuration. The variant bodies live in
# sibling files and merge into `flake.lib.guernica` — composed here through
# the fixed point, never by relative import.
{ config, ... }:
let
  inherit (config.flake.lib.custom) themeLib;
  inherit (config.flake.lib.guernica) waybarModules mkWaybarDefault mkWaybarCompact;
in
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      lib,
      ...
    }:
    let
      # The window manager in use is a fact of the composed configuration,
      # not a selector option.
      windowManager = if config.programs.niri.enable then "niri" else "hyprland";
      uiCfg = { inherit windowManager; };
    in
    {
      stylix.targets.waybar = themeLib.whenTheme config "guernica" {
        enable = false;
        addCss = false;
        enableCenterBackColors = false;
        enableLeftBackColors = false;
        enableRightBackColors = false;
      };

      programs.waybar = themeLib.withVariant config "guernica" {
        default = mkWaybarDefault {
          inherit lib config uiCfg waybarModules;
        };
        compact = mkWaybarCompact {
          inherit lib config uiCfg waybarModules;
        };
      };
    };
}
