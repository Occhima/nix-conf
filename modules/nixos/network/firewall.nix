{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib) mkEnableOption;

  cfg = config.modules.network.firewall;
in
{
  options.modules.network.firewall = {
    enable = mkEnableOption "firewall configuration";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      package = pkgs.iptables;

      allowedTCPPorts = [
        443
        8080
      ];
      allowedUDPPorts = [ ];

      allowPing = false;

      logReversePathDrops = true;
      logRefusedConnections = false;

      checkReversePath = mkForce false;
    };
  };
}
