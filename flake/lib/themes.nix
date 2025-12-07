{ lib }:

{
  themeLib =
    let
      getCfg = config: config.modules.desktop.ui.themes;
    in
    {
      whenTheme =
        config: themeName: targetConfig:
        let
          cfg = getCfg config;
        in
        lib.mkIf (cfg.enable && cfg.name == themeName) targetConfig;

      withVariant =
        config: themeName: variantConfigs:
        let
          cfg = getCfg config;
          isActive = cfg.enable && cfg.name == themeName;
          selectedConfig = variantConfigs.${cfg.variant} or variantConfigs.default;
        in
        lib.mkIf isActive selectedConfig;

      isThemeActive =
        config: themeName:
        let
          cfg = getCfg config;
        in
        cfg.enable && cfg.name == themeName;

      isVariant =
        config: variantName:
        let
          cfg = getCfg config;
        in
        cfg.variant == variantName;
    };
}
