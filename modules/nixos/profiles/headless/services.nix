{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "headless" ]) {
    # a headless system should not mount any removable media
    # without explicit user action
    services.udisks2.enable = mkForce false;
  };
}
