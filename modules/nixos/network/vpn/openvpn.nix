{ ... }:
{
  config.flake.modules.nixos.vpn-openvpn =
    {
      config,
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
