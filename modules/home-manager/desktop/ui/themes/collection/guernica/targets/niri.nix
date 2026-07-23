# Guernica integration for niri. Import this module (together with the plain
# Requires `themes-guernica` in the same composition (homeManager.desktop provides it).
# `niri` module) to apply Guernica styling to niri; the plain niri module no
# longer carries any theme configuration.
{ inputs, ... }:
{
  flake.modules.homeManager.themes-guernica-niri =
    {
      ...
    }:
    {
      imports = [
        inputs.niri.homeModules.stylix
      ];
      stylix.targets.niri.enable = true;

      programs.niri = {
        settings = {
          overview = {
            workspace-shadow.enable = false;
            backdrop-color = "transparent";
          };
          layout = {
            focus-ring.enable = false;
            shadow = {
              enable = true;
            };
            preset-column-widths = [
              { proportion = 0.25; }
              { proportion = 0.5; }
              { proportion = 0.75; }
              { proportion = 1.0; }
            ];
            default-column-width = {
              proportion = 0.5;
            };

            gaps = 20;

            tab-indicator = {
              hide-when-single-tab = true;
              place-within-column = true;
              position = "left";
              corner-radius = 20.0;
              gap = -12.0;
              gaps-between-tabs = 10.0;
              width = 4.0;
              length.total-proportion = 0.1;
            };
          };

          layer-rules = [ ];
          window-rules = [ ];
        };
      };
    };
}
