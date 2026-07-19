{
  flake.modules.nixos.vpn-openvpn =
    {
      pkgs,
      ...
    }:
    {
      options.modules.network.vpn.openvpn = {

      };

      config = {
        boot.kernelModules = [ "tun" ];
        programs.openvpn3.enable = true;
        environment.systemPackages = [ pkgs.openvpn ];
      };
    };
}
