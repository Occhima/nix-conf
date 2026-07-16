{ ... }:
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      inputs,
      lib,
      ...
    }:
    let
      inherit (lib.custom) themeLib;
      isGuernica = themeLib.isThemeActive config "guernica";
      isCompact = themeLib.isVariant config "compact";
      usingNiri = config.programs.niri.enable;
    in
    {
      imports = [ inputs.self.modules.homeManager.themes-stylix ];

      config = {
        modules.desktop.ui.themes = {
          name = lib.mkDefault "guernica";
          registry.guernica.meta = {
            name = "Guernica";
            description = "Dark theme with Polykai color scheme";
            variants = [
              "default"
              "compact"
            ];
            maintainer = "occhima";
          };
        };

        assertions = [
          {
            assertion = !(isGuernica && isCompact && usingNiri);
            message = "Compact variant is not supported for niri window manager yet.";
          }
        ];
      };
    };
}
