{
  flake.modules.nixos.firewall =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.modules) mkForce;
    in
    {
      options.modules.network.firewall = {
      };

      config = {
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
    };
}
