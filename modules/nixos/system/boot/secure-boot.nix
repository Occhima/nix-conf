{ inputs, ... }:
{
  occhima.boot-secure-boot.nixos =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.modules) mkForce;
    in
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
      options.modules.system.boot.secureBoot = {
      };

      config = {
        environment.systemPackages = [ pkgs.sbctl ];

        boot.loader.systemd-boot.enable = mkForce false;

        boot = {
          bootspec.enable = true;
          lanzaboote = {
            enable = true;
            pkiBundle = "/etc/secureboot";
          };
        };
      };
    };
}
