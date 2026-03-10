{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.custom) themeLib;
  stylixColors = config.lib.stylix.colors;

  colorsQml = pkgs.writeText "Colors.qml" ''
    pragma Singleton
    import QtQuick

    QtObject {
      // Base16 color scheme: ${config.stylix.base16Scheme.name or "guernica"}
      readonly property color background: "#${stylixColors.base00}"
      readonly property color backgroundAlt: "#${stylixColors.base01}"
      readonly property color surface: "#${stylixColors.base02}"
      readonly property color comment: "#${stylixColors.base03}"
      readonly property color foregroundDim: "#${stylixColors.base04}"
      readonly property color foreground: "#${stylixColors.base05}"
      readonly property color foregroundAlt: "#${stylixColors.base06}"
      readonly property color foregroundBright: "#${stylixColors.base07}"

      readonly property color accent: "#${stylixColors.base08}"
      readonly property color link: "#${stylixColors.base09}"
      readonly property color success: "#${stylixColors.base0A}"
      readonly property color warning: "#${stylixColors.base0B}"
      readonly property color secondary: "#${stylixColors.base0C}"
      readonly property color primary: "#${stylixColors.base0D}"
      readonly property color error: "#${stylixColors.base0E}"
      readonly property color urgent: "#${stylixColors.base0F}"

      // Semantic aliases
      readonly property color text: foreground
      readonly property color textDim: foregroundDim
      readonly property color border: surface
      readonly property color selection: surface
    }
  '';
in
{
  config = themeLib.whenTheme config "guernica" {
    xdg.configFile."quickshell/theme/Colors.qml".source = colorsQml;
    xdg.configFile."quickshell/theme/qmldir".text = ''
      module Theme
      singleton Colors 1.0 Colors.qml
    '';

    home.sessionVariables = {
      QUICKSHELL_THEME_BG = "#${stylixColors.base00}";
      QUICKSHELL_THEME_FG = "#${stylixColors.base05}";
      QUICKSHELL_THEME_ACCENT = "#${stylixColors.base0D}";
      QUICKSHELL_THEME_ERROR = "#${stylixColors.base0E}";
      QUICKSHELL_THEME_SUCCESS = "#${stylixColors.base0A}";
    };
  };
}
