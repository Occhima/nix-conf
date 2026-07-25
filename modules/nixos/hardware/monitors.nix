# Structured monitor data: typed fields only. Renderers (Hyprland, Niri)
# may turn these into compositor-specific strings; nothing parses structure
# back out of strings.
{ ... }: {
  flake.modules.nixos.monitors =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (lib) mkOption types literalExpression;
      monitorOptions = {
        options = {
          output = mkOption {
            type = types.str;
            example = "DP-1";
            description = "The name/connector of the monitor";
          };

          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Whether the monitor is enabled";
          };

          width = mkOption {
            type = types.int;
            example = 2560;
            description = "Horizontal resolution in pixels";
          };

          height = mkOption {
            type = types.int;
            example = 1080;
            description = "Vertical resolution in pixels";
          };

          refreshRate = mkOption {
            type = types.nullOr types.number;
            default = null;
            example = 180;
            description = "Refresh rate in Hz (null lets the compositor pick)";
          };

          x = mkOption {
            type = types.int;
            default = 0;
            description = "Horizontal position in the global layout";
          };

          y = mkOption {
            type = types.int;
            default = 0;
            description = "Vertical position in the global layout";
          };

          scale = mkOption {
            type = types.number;
            default = 1.0;
            description = "The scale factor for the monitor";
          };

          transform = mkOption {
            type = types.int;
            default = 0;
            description = "Compositor transform value (0 = normal)";
          };

          extraConfig = mkOption {
            type = types.attrs;
            default = { };
            description = "Additional configuration options for this monitor";
          };
        };
      };
    in
    {
      options.modules.hardware.monitors = {
        primaryMonitorName = mkOption {
          type = types.str;
          default = "";
          description = "The identifier of the primary monitor";
        };

        displays = mkOption {
          type = types.attrsOf (types.submodule monitorOptions);
          default = { };
          description = "Monitor configuration for use with window managers and display utilities";
          example = literalExpression ''
            {
              dp1 = {
                output = "DP-1";
                width = 2560;
                height = 1440;
                refreshRate = 144;
                x = 0;
                y = 0;
              };
              hdmi1 = {
                output = "HDMI-1";
                width = 1920;
                height = 1080;
                x = 2560;
                y = 0;
              };
            }
          '';
        };
      };

      config = {
        assertions = [
          {
            assertion =
              let
                monitors = config.modules.hardware.monitors;
              in
              monitors.primaryMonitorName == "" || builtins.hasAttr monitors.primaryMonitorName monitors.displays;
            message = "modules.hardware.monitors.primaryMonitorName must name a declared display";
          }
        ];
      };
    };
}
