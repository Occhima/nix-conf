{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.services.resolved;
in
{
  options.modules.services.resolved = {
    enable = mkEnableOption "Enable systemd-resolved for DNS resolution";
  };

  config = mkIf cfg.enable {
    # Configure systemd-resolved for DNS resolution
    services.resolved = {
      enable = true;
      fallbackDns = [
        "1.1.1.1"
        "9.9.9.9"
        "8.8.8.8"
        "2606:4700:4700::1111"
      ];
      extraConfig = ''
        DNSOverTLS=opportunistic
        MulticastDNS=yes
        Cache=yes
        DNSStubListener=yes
      '';
    };

    # Set resolved as the system nameserver
    networking.nameservers = [ "127.0.0.53" ];

    # Use systemd-resolved for DNS resolution
    environment.etc."resolv.conf".source =
      "${config.services.resolved.package}/lib/systemd/resolv.conf";
  };
}
