{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
  colors = config.lib.stylix.colors;
  guernicaTheme = with colors; {
    defs = {
      bg = "#${base00}";
      bg_panel = "#${base01}";
      bg_element = "#${base02}";
      border = "#${base03}";
      fg = "#${base05}";
      fg_muted = "#${base04}";
      accent = "#${base0D}";
      secondary = "#${base09}";
      warning = "#${base08}";
      success = "#${base0A}";
      info = "#${base0D}";
      error = "#${base0E}";
      string = "#${base0B}";
      operator = "#${base0C}";
    };

    theme = {
      primary = "accent";
      secondary = "secondary";
      accent = "accent";
      error = "error";
      warning = "warning";
      success = "success";
      info = "info";
      text = "fg";
      textMuted = "fg_muted";
      background = "bg";
      backgroundPanel = "bg_panel";
      backgroundElement = "bg_element";
      border = "border";
      borderActive = "accent";
      borderSubtle = "bg_element";
      markdownText = "fg";
      markdownHeading = "accent";
      markdownLink = "secondary";
      markdownCode = "string";
      syntaxKeyword = "error";
      syntaxFunction = "accent";
      syntaxString = "string";
      syntaxOperator = "operator";
    };
  };
in
{
  programs.opencode = themeLib.whenTheme config "guernica" {
    themes.guernica = guernicaTheme;
    settings.theme = "guernica";
  };
}
