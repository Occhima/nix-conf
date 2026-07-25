{
  flake.modules.nixos.firewall = { pkgs, ... }: {
    # Services own their ports; the pentesting container module opens 8080.
    networking.firewall = {
      enable = true;
      package = pkgs.iptables;

      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];

      allowPing = false;

      logReversePathDrops = true;
      logRefusedConnections = false;
    };
  };
}
