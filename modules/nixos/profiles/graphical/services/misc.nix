{ ... }:
{
  config.occhima.graphical.nixos =
    { lib, ... }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
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
