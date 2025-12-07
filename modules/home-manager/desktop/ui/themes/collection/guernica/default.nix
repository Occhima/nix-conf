{ config, lib, ... }:
let
  inherit (lib.custom) themeLib;

  uiCfg = config.modules.desktop.ui;

  isGuernica = themeLib.isThemeActive config "guernica";
  isCompact = themeLib.isVariant config "compact";
  usingNiri = uiCfg.windowManager == "niri";

in
{

  imports = [
    ./targets
    ./colors.nix
    ./fonts.nix
    ./config.nix
  ];

  config = {

    modules.desktop.ui.themes.registry.guernica = {
      meta = {
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
}
