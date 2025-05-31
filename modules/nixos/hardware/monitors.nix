{
  lib,
  ...
}:

let
  inherit (lib) mkOption types literalExpression;
  monitorOptions = {
    options = {
      name = mkOption {
        type = types.str;
        example = "DP-1";
        description = "The name/connector of the monitor";
      };

      mode = mkOption {
        type = types.str;
        default = "preferred";
        example = "1920x1080@144";
        description = "The mode (resolution and refresh rate) to use for the monitor";
      };

      position = mkOption {
        type = types.str;
        default = "auto";
        example = "1920,0";
        description = "The position coordinates for the monitor";
      };

      scale = mkOption {
        type = types.number;
        default = 1.0;
        description = "The scale factor for the monitor";
      };

      transform = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to rotate the monitor";
      };

      disable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to disable the monitor";
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
            name = "DP-1";
            mode = "2560x1440@144";
            position = "0,0";
          };
          hdmi1 = {
            name = "HDMI-1";
            mode = "1920x1080";
            position = "2560,0";
          };
        }
      '';
    };
  };
}
