{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
  inherit (lib) mkIf;

  uiCfg = config.modules.desktop.ui;
  stylixColors = config.lib.stylix.colors;
in
{
  xdg.configFile."quickshell/data/Settings.qml" = mkIf (uiCfg.dock == "quickshell") (
    themeLib.whenTheme config "guernica" {
      text = ''
        pragma Singleton

        import QtQuick

        QtObject {
            readonly property color bgColor: "#${stylixColors.base00}"
            readonly property color bgColorTranslucent: Qt.rgba(0.078, 0.094, 0.094, 0.85)
            readonly property color bgLight: "#${stylixColors.base01}"
            readonly property color bgLightTranslucent: Qt.rgba(0.118, 0.141, 0.141, 0.9)
            readonly property color bgLighter: "#${stylixColors.base02}"
            readonly property color fgColor: "#${stylixColors.base05}"
            readonly property color fgDim: "#${stylixColors.base03}"
            readonly property color accentColor: "#${stylixColors.base0D}"
            readonly property color warningColor: "#${stylixColors.base08}"
            readonly property color successColor: "#${stylixColors.base0A}"
            readonly property color errorColor: "#${stylixColors.base0E}"
            readonly property color purpleColor: "#${stylixColors.base0C}"
            readonly property color blueColor: "#${stylixColors.base09}"
            readonly property color yellowColor: "#${stylixColors.base0B}"

            readonly property color borderSubtle: Qt.rgba(1, 1, 1, 0.06)
            readonly property color borderNormal: Qt.rgba(1, 1, 1, 0.08)
            readonly property color borderHover: Qt.rgba(1, 1, 1, 0.12)
            readonly property color hoverBg: Qt.rgba(1, 1, 1, 0.1)

            readonly property int rounding: 14
            readonly property int barHeight: 40
            readonly property int barMargin: 8
            readonly property int barSideMargin: 16
        }
      '';
    }
  );
}
