{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.security.tor;
in
{
  options.modules.security.tor = {
    enable = mkEnableOption "Enable Tor configuration";

    client = mkEnableOption "Enable Tor client functionality";

    relay = mkEnableOption "Configure as a Tor relay";
  };

  config = mkIf cfg.enable {
    # Basic Tor configuration
    services.tor = {
      enable = true;
      client.enable = cfg.client;

      settings = {
        ClientUseIPv4 = true;
        ClientUseIPv6 = true;
        ClientPreferIPv6ORPort = true;

        AutomapHostsOnResolve = true;
        AutomapHostsSuffixes = [
          ".onion"
          ".exit"
        ];

        SafeSocks = 1;
        DNSPort = 9053;
      };

      relay = mkIf cfg.relay {
        enable = true;
        role = "relay"; # Can be "bridge", "exit", or "relay"

        # Set appropriate bandwidth limits if you're running a relay
        bandwidthRate = "1 MBytes";
        bandwidthBurst = "2 MBytes";
      };

      torsocks = {
        enable = true;
        server = "127.0.0.1:9050";
      };
    };

    # Add torsocks to environment
    environment.systemPackages = with pkgs; [
      tor
      torsocks
    ];

    # Open firewall ports if running as a relay
    networking.firewall = mkIf cfg.relay {
      allowedTCPPorts = [ 9001 ]; # ORPort
      allowedUDPPorts = [ 9001 ];
    };
  };
}
