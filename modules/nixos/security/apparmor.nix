{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.meta) getExe;
in
{
  services.dbus.apparmor = "disabled";

  security.apparmor = {
    enable = true;
    enableCache = true;
    killUnconfinedConfinables = true;
    packages = [ pkgs.apparmor-profiles ];

    policies = {
      "default_deny" = {
        state = "disable";
        profile = ''
          profile default_deny /** { }
        '';
      };

      "sudo" = {
        state = "disable";
        profile = ''
          ${getExe pkgs.sudo} {
            file /** rwlkUx,
          }
        '';
      };

      "nix" = {
        state = "disable";
        profile = ''
          ${getExe config.nix.package} {
            unconfined,
          }
        '';
      };
    };
  };
}
