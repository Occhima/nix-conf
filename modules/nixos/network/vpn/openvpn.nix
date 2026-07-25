{
  flake.modules.nixos.vpn-openvpn = { pkgs, ... }: {
    boot.kernelModules = [ "tun" ];
    programs.openvpn3.enable = true;
    environment.systemPackages = [ pkgs.openvpn ];

    # NetworkManager OpenVPN plugin (contributed here, not by the NM module).
    networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

    # VPN routes fail strict reverse-path filtering; relax narrowly here.
    networking.firewall.checkReversePath = "loose";
  };
}
