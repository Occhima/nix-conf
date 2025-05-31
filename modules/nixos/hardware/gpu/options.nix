{
  lib,
  ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.modules.hardware.gpu = {
    type = mkOption {
      type = types.nullOr (
        types.enum [
          "amd"
          "intel"
          "nvidia"
        ]
      );
      default = null;
      description = "The GPU manufacturer and type";
    };
  };
}
