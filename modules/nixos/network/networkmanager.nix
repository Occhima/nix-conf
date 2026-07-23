{
  flake.modules.nixos.networkmanager =
    { ... }:
    {
      # NetworkManager owns the Wi-Fi backend. The tray applet lives in the
      # graphical composition (nixos.graphical); the OpenVPN plugin is
      # contributed by the vpn-openvpn module.
      networking.networkmanager = {
        enable = true;
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
