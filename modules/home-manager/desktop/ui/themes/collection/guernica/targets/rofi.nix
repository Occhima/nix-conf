{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.desktop.ui.themes;
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  stylix.targets.rofi.enable = lib.mkIf (cfg.enable && cfg.name == "guernica") false;

  programs.rofi.theme = lib.mkIf (cfg.enable && cfg.name == "guernica") {
    # /* MACOS SPOTLIGHT LIKE THEME FOR ROFI  */
    #/* Author: Newman Sanchez (https://github.com/newmanls) */   # MacOS Spotlight-like theme
    "*" = {
      bg0 = mkLiteral "#F5F5F5BF";
      bg1 = mkLiteral "#7E7E7E80";
      bg2 = mkLiteral "#0860F2E6";

      fg0 = mkLiteral "#242424";
      fg1 = mkLiteral "#FFFFFF";
      fg2 = mkLiteral "#24242480";

      text-color = mkLiteral "@fg0";

      margin = mkLiteral "0";
      padding = mkLiteral "0";
      spacing = mkLiteral "0";
    };

    "window" = {
      background-color = mkLiteral "@bg0";
      location = mkLiteral "center";
      width = mkLiteral "640";
      border-radius = mkLiteral "8";
    };

    "inputbar" = {
      padding = mkLiteral "12px";
      spacing = mkLiteral "12px";
      children = mkLiteral "[ icon-search, entry ]";
    };

    "icon-search" = {
      expand = mkLiteral "false";
      filename = mkLiteral "\"search\"";
      size = mkLiteral "28px";
    };

    "icon-search, entry, element-icon, element-text" = {
      vertical-align = mkLiteral "0.5";
    };

    "entry" = {
      font = mkLiteral "inherit";
      placeholder = mkLiteral "\"Search\"";
      placeholder-color = mkLiteral "@fg2";
    };

    "message" = {
      border = mkLiteral "2px 0 0";
      border-color = mkLiteral "@bg1";
      background-color = mkLiteral "@bg1";
    };

    "textbox" = {
      padding = mkLiteral "8px 24px";
    };

    "listview" = {
      lines = mkLiteral "10";
      columns = mkLiteral "1";
      fixed-height = mkLiteral "false";
      border = mkLiteral "1px 0 0";
      border-color = mkLiteral "@bg1";
    };

    "element" = {
      padding = mkLiteral "8px 16px";
      spacing = mkLiteral "16px";
      background-color = mkLiteral "transparent";
    };

    "element normal active" = {
      text-color = mkLiteral "@bg2";
    };

    "element alternate active" = {
      text-color = mkLiteral "@bg2";
    };

    "element selected normal, element selected active" = {
      background-color = mkLiteral "@bg2";
      text-color = mkLiteral "@fg1";
    };

    "element-icon" = {
      size = mkLiteral "1em";
    };

    "element-text" = {
      text-color = mkLiteral "inherit";
    };
  };
}
