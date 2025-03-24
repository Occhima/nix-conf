{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.system.boot.secureBoot;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
  options.modules.system.boot.secureBoot = {
    enable = mkEnableOption "secure boot using lanzaboote";
  };

  config = mkIf cfg.enable {
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
}
