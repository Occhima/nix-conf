# Theme helpers. Themes are activated by importing their aspect; the only
# theme-wide datum left is the variant, and these helpers key values on it.
{ ... }:
{
  flake.lib.custom.themeLib = {
    isVariant = config: variantName: config.modules.desktop.ui.themes.variant == variantName;

    # Pick a value per variant, falling back to `default`.
    forVariant =
      config: variants: variants.${config.modules.desktop.ui.themes.variant} or variants.default;
  };
}
