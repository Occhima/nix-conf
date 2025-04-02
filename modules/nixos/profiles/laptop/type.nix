{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "laptop" ]) {
    modules.device.type = "laptop";
  };
}
