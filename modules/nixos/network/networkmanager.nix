{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.network.networkmanager;
in
{
  options.modules.network.networkmanager = {
    enable = mkEnableOption "NetworkManager configuration";
  };

  config = mkIf cfg.enable {
    networking.networkmanager = {
      enable = true;
      plugins = mkForce [ pkgs.networkmanager-openvpn ];
      dns = "systemd-resolved";
      unmanaged = [
        "interface-name:tailscale*"
        "interface-name:br-*"
        "interface-name:rndis*"
        "interface-name:docker*"
        "interface-name:virbr*"
        "interface-name:vboxnet*"
        "interface-name:waydroid*"
        "type:bridge"
      ];
      wifi = {
        backend = "wpa_supplicant";
        powersave = true;
        scanRandMacAddress = true;
      };
      ethernet.macAddress = "random";
    };
  };
}
