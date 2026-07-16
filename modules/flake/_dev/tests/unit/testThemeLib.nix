{ lib, ... }:
let
  inherit (lib.custom) themeLib;

  mkMockConfig = variant: {
    modules.desktop.ui.themes = {
      inherit variant;
    };
  };
in
{
  "isVariant matches the configured variant" = {
    expr = themeLib.isVariant (mkMockConfig "compact") "compact";
    expected = true;
  };

  "isVariant rejects other variants" = {
    expr = themeLib.isVariant (mkMockConfig "default") "compact";
    expected = false;
  };

  "forVariant picks the configured variant" = {
    expr = themeLib.forVariant (mkMockConfig "compact") {
      default = "a";
      compact = "b";
    };
    expected = "b";
  };

  "forVariant falls back to default when a variant is not provided" = {
    expr = themeLib.forVariant (mkMockConfig "compact") {
      default = "a";
    };
    expected = "a";
  };
}
