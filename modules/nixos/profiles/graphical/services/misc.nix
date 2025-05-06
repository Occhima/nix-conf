{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkDefault;
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "graphical" ]) {
    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;

      dbus = {
        enable = true;
      };

      timesyncd.enable = mkDefault true;
      chrony.enable = mkDefault false;
    };
  };
}
