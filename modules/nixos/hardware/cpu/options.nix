{
  lib,
  ...
}:

with lib;

{
  options.modules.hardware.cpu = {
    type = mkOption {
      type = types.nullOr (
        types.enum [
          "amd"
          "intel"
        ]
      );
      default = null;
      description = "The CPU manufacturer and type";
    };
  };
}
