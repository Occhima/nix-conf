# Theme helpers: conditional values keyed on the theme data options
# (`modules.desktop.ui.themes.{name,variant}`). Themes are activated by
# importing their aspect; these helpers only gate *values* inside an
# already-imported theme.
{ lib, ... }:
{
  flake.lib.custom.themeLib =
    let
      getCfg = config: config.modules.desktop.ui.themes;
    in
    rec {
      whenTheme =
        config: themeName: targetConfig:
        let
          cfg = getCfg config;
        in
        lib.mkIf ((cfg.enable or true) && cfg.name == themeName) targetConfig;

      whenThemeAfter =
        config: themeName: targetConfig:
        whenTheme config themeName (lib.mkAfter targetConfig);

      withVariant =
        config: themeName: variantConfigs:
        let
          cfg = getCfg config;
          isActive = (cfg.enable or true) && cfg.name == themeName;
          selectedConfig = variantConfigs.${cfg.variant} or variantConfigs.default;
        in
        lib.mkIf isActive selectedConfig;

      withVariantAfter =
        config: themeName: variantConfigs:
        withVariant config themeName (lib.mapAttrs (_: lib.mkAfter) variantConfigs);

      isThemeActive =
        config: themeName:
        let
          cfg = getCfg config;
        in
        (cfg.enable or true) && cfg.name == themeName;

      isVariant =
        config: variantName:
        let
          cfg = getCfg config;
        in
        cfg.variant == variantName;
    };
}
