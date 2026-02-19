{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.lists) optionals;
  inherit (lib) mkEnableOption;

  cfg = config.modules.network.networkmanager;
  isGui = config.modules.system.display.type != null;
in
{
  options.modules.network.networkmanager = {
    enable = mkEnableOption "NetworkManager configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = optionals isGui [
      pkgs.networkmanagerapplet
    ];

    networking.networkmanager = {
      enable = true;
      plugins = mkForce (optionals isGui [ pkgs.networkmanager-openvpn ]);
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
        powersave = false;
        scanRandMacAddress = true;
      };
      ethernet.macAddress = "random";
    };
  };
}
