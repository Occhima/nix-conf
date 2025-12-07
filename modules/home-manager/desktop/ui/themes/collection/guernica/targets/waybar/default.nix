{ config, lib, ... }:
let
  inherit (lib.custom) themeLib;
  uiCfg = config.modules.desktop.ui;

  defaultVariant = import ./modules/default-variant.nix { inherit lib config uiCfg; };
  compactVariant = import ./modules/compact-variant.nix { inherit lib config uiCfg; };
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
    default = defaultVariant;
    compact = compactVariant;
  };
}
