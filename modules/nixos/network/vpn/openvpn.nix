{
  lib,
  config,
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
    programs.openvpn3.enable = true;
    services.openvpn.servers = { };
  };
}
