{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;

  cfg = config.modules.network.vpn.openvpn;
in
{
  options.modules.network.vpn.openvpn = {
    enable = mkEnableOption "OpenVPN";

  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];
    programs.openvpn3.enable = true;
    environment.systemPackages = [ pkgs.openvpn ];
  };
}
