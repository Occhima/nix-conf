{ lib, pkgs, ... }:
let
  inherit (lib.modules) mkForce;
in
{

  hardware.wirelessRegulatoryDatabase = true;
  networking.networkmanager = {
    enable = true;
    plugins = mkForce [ ];
    wifi = {
      backend = "wpa_supplicant";
      powersave = true;
      scanRandMacAddress = true;
    };
  };

  networking.wireless = {
    enable = true;
    allowAuxiliaryImperativeNetworks = true;
  };

  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];

  environment.systemPackages = [
    pkgs.wpa_supplicant
  ];
}
