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
  # Override quickshell Settings.qml with Guernica/Polykai colors from stylix
  xdg.configFile."quickshell/data/Settings.qml" = mkIf (uiCfg.dock == "quickshell") (
    themeLib.whenTheme config "guernica" {
      text = ''
        pragma Singleton

        import QtQuick

        QtObject {
            // Guernica / Polykai color scheme (from stylix)
            readonly property string bgColor: "#${stylixColors.base00}"
            readonly property string bgLight: "#${stylixColors.base01}"
            readonly property string bgLighter: "#${stylixColors.base02}"
            readonly property string fgColor: "#${stylixColors.base05}"
            readonly property string fgDim: "#${stylixColors.base03}"
            readonly property string accentColor: "#${stylixColors.base0D}"
            readonly property string warningColor: "#${stylixColors.base08}"
            readonly property string successColor: "#${stylixColors.base0A}"
            readonly property string errorColor: "#${stylixColors.base0E}"
            readonly property string purpleColor: "#${stylixColors.base0C}"
            readonly property string blueColor: "#${stylixColors.base09}"
            readonly property string yellowColor: "#${stylixColors.base0B}"

            readonly property int rounding: 14
            readonly property int barWidth: 48
            readonly property int barMargin: 10
        }
      '';
    }
  );
}
