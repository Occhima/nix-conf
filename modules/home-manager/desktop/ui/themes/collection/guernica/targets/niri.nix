# Guernica integration for Niri. The plain compositor aspect stays reusable;
# importing this target adds the rice and its wallpaper service.
{ inputs, ... }:
{
  flake.modules.homeManager.themes-guernica-niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.niri.homeModules.stylix ];
      stylix.targets.niri.enable = true;

      home.packages = [ pkgs.swaybg ];

      systemd.user.services.niri-wallpaper = {
        Unit = {
          Description = "Guernica wallpaper for Niri";
          After = [ "niri.service" ];
          PartOf = [ "niri.service" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} --mode fill --image ${config.stylix.image}";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "niri.service" ];
      };

      programs.niri.settings = {
        overview = {
          workspace-shadow.enable = false;
          backdrop-color = "transparent";
        };
        layout = {
          focus-ring.enable = false;
          shadow = {
            enable = true;
            softness = 30;
            spread = 5;
            offset = {
              x = 0;
              y = 5;
            };
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
        window-rules = [
          {
            geometry-corner-radius = {
              top-left = 5.0;
              top-right = 5.0;
              bottom-left = 5.0;
              bottom-right = 5.0;
            };
            clip-to-geometry = true;
          }
        ];
      };
    };
}
