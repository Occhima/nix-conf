{ lib, ... }:
let
  inherit (lib.custom) themeLib;

  # Mock config for testing
  mkMockConfig =
    {
      themeName ? "guernica",
      themeEnabled ? true,
      variant ? "default",
    }:
    {
      modules.desktop.ui.themes = {
        enable = themeEnabled;
        name = themeName;
        variant = variant;
      };
    };

  # Helper to check if result is an mkIf with true condition
  isActiveCondition = result: result._type or null == "if" && result.condition == true;

  # Helper to check if result is an mkIf with false condition
  isInactiveCondition = result: result._type or null == "if" && result.condition == false;

  # Helper to get content from mkIf result
  getContent = result: result.content;
in
{
  # ============= whenTheme Tests =============

  "whenTheme creates active condition when theme is active" = {
    expr =
      let
        mockConfig = mkMockConfig { };
        result = themeLib.whenTheme mockConfig "guernica" { foo = "bar"; };
      in
      isActiveCondition result;
    expected = true;
  };

  "whenTheme includes correct content when active" = {
    expr =
      let
        mockConfig = mkMockConfig { };
        result = themeLib.whenTheme mockConfig "guernica" { foo = "bar"; };
      in
      (getContent result).foo;
    expected = "bar";
  };

  "whenTheme creates inactive condition when theme is disabled" = {
    expr =
      let
        mockConfig = mkMockConfig { themeEnabled = false; };
        result = themeLib.whenTheme mockConfig "guernica" { foo = "bar"; };
      in
      isInactiveCondition result;
    expected = true;
  };

  "whenTheme creates inactive condition when theme name does not match" = {
    expr =
      let
        mockConfig = mkMockConfig { themeName = "other-theme"; };
        result = themeLib.whenTheme mockConfig "guernica" { foo = "bar"; };
      in
      isInactiveCondition result;
    expected = true;
  };

  "whenTheme preserves complex nested config in content" = {
    expr =
      let
        mockConfig = mkMockConfig { };
        targetConfig = {
          programs.waybar = {
            enable = true;
            settings.mainBar.height = 30;
          };
        };
        result = themeLib.whenTheme mockConfig "guernica" targetConfig;
      in
      (getContent result).programs.waybar.settings.mainBar.height;
    expected = 30;
  };

  # ============= withVariant Tests =============

  "withVariant creates active condition with default variant" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "default"; };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            style = "minimal";
          };
          compact = {
            style = "dense";
          };
        };
      in
      isActiveCondition result;
    expected = true;
  };

  "withVariant selects default variant content correctly" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "default"; };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            style = "minimal";
          };
          compact = {
            style = "dense";
          };
        };
      in
      (getContent result).style;
    expected = "minimal";
  };

  "withVariant selects compact variant content correctly" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "compact"; };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            style = "minimal";
          };
          compact = {
            style = "dense";
          };
        };
      in
      (getContent result).style;
    expected = "dense";
  };

  "withVariant falls back to default when variant not found" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "nonexistent"; };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            style = "minimal";
          };
          compact = {
            style = "dense";
          };
        };
      in
      (getContent result).style;
    expected = "minimal";
  };

  "withVariant creates inactive condition when theme is disabled" = {
    expr =
      let
        mockConfig = mkMockConfig {
          themeEnabled = false;
          variant = "compact";
        };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            style = "minimal";
          };
          compact = {
            style = "dense";
          };
        };
      in
      isInactiveCondition result;
    expected = true;
  };

  "withVariant creates inactive condition when theme name does not match" = {
    expr =
      let
        mockConfig = mkMockConfig {
          themeName = "other-theme";
          variant = "compact";
        };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            style = "minimal";
          };
          compact = {
            style = "dense";
          };
        };
      in
      isInactiveCondition result;
    expected = true;
  };

  "withVariant handles complex nested variant configs" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "compact"; };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            programs.waybar.settings.mainBar = {
              height = 30;
              position = "top";
            };
          };
          compact = {
            programs.waybar.settings.mainBar = {
              height = 34;
              position = "top";
            };
          };
        };
      in
      (getContent result).programs.waybar.settings.mainBar.height;
    expected = 34;
  };

  # ============= isThemeActive Tests =============

  "isThemeActive returns true when theme is active" = {
    expr =
      let
        mockConfig = mkMockConfig { };
      in
      themeLib.isThemeActive mockConfig "guernica";
    expected = true;
  };

  "isThemeActive returns false when theme is disabled" = {
    expr =
      let
        mockConfig = mkMockConfig { themeEnabled = false; };
      in
      themeLib.isThemeActive mockConfig "guernica";
    expected = false;
  };

  "isThemeActive returns false when theme name does not match" = {
    expr =
      let
        mockConfig = mkMockConfig { themeName = "other-theme"; };
      in
      themeLib.isThemeActive mockConfig "guernica";
    expected = false;
  };

  "isThemeActive returns false when both disabled and name mismatch" = {
    expr =
      let
        mockConfig = mkMockConfig {
          themeEnabled = false;
          themeName = "other-theme";
        };
      in
      themeLib.isThemeActive mockConfig "guernica";
    expected = false;
  };

  # ============= isVariant Tests =============

  "isVariant returns true for default variant" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "default"; };
      in
      themeLib.isVariant mockConfig "default";
    expected = true;
  };

  "isVariant returns true for compact variant" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "compact"; };
      in
      themeLib.isVariant mockConfig "compact";
    expected = true;
  };

  "isVariant returns false when variant does not match" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "default"; };
      in
      themeLib.isVariant mockConfig "compact";
    expected = false;
  };

  "isVariant works independently of theme enable state" = {
    expr =
      let
        mockConfig = mkMockConfig {
          themeEnabled = false;
          variant = "compact";
        };
      in
      themeLib.isVariant mockConfig "compact";
    expected = true;
  };

  "isVariant works independently of theme name" = {
    expr =
      let
        mockConfig = mkMockConfig {
          themeName = "other-theme";
          variant = "compact";
        };
      in
      themeLib.isVariant mockConfig "compact";
    expected = true;
  };

  # ============= Combined Usage Tests =============

  "isThemeActive and isVariant can be used together" = {
    expr =
      let
        mockConfig = mkMockConfig {
          themeName = "guernica";
          themeEnabled = true;
          variant = "compact";
        };
        isGuernica = themeLib.isThemeActive mockConfig "guernica";
        isCompact = themeLib.isVariant mockConfig "compact";
      in
      isGuernica && isCompact;
    expected = true;
  };

  "whenTheme and withVariant compose correctly" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "compact"; };
        # First apply withVariant
        innerResult = themeLib.withVariant mockConfig "guernica" {
          default = {
            mode = "default";
          };
          compact = {
            mode = "compact";
          };
        };
        # Then apply whenTheme with the inner result
        outerResult = themeLib.whenTheme mockConfig "guernica" {
          settings = getContent innerResult;
        };
      in
      (getContent outerResult).settings.mode;
    expected = "compact";
  };

  "theme library handles multiple theme checks" = {
    expr =
      let
        mockConfig = mkMockConfig { themeName = "guernica"; };
        guernicaActive = themeLib.isThemeActive mockConfig "guernica";
        otherActive = themeLib.isThemeActive mockConfig "catppuccin";
      in
      guernicaActive && !otherActive;
    expected = true;
  };

  # ============= Edge Cases =============

  "whenTheme handles empty target config" = {
    expr =
      let
        mockConfig = mkMockConfig { };
        result = themeLib.whenTheme mockConfig "guernica" { };
      in
      getContent result;
    expected = { };
  };

  "withVariant handles single variant definition" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "nonexistent"; };
        result = themeLib.withVariant mockConfig "guernica" {
          default = {
            value = 42;
          };
        };
      in
      (getContent result).value;
    expected = 42;
  };

  "isVariant handles arbitrary variant names" = {
    expr =
      let
        mockConfig = mkMockConfig { variant = "custom-super-variant"; };
      in
      themeLib.isVariant mockConfig "custom-super-variant";
    expected = true;
  };
}
