{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.services.printing;
in
{
  options.modules.services.printing = {
    enable = mkEnableOption "Enable printing support";

    drivers = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional printer drivers to install";
      example = literalExpression "[ pkgs.gutenprint pkgs.hplip ]";
    };

    avahi = mkEnableOption "Enable network printer discovery with Avahi/Bonjour";
  };

  config = mkIf cfg.enable {
    # Basic printing setup with CUPS
    services.printing = {
      enable = true;
      drivers = cfg.drivers;

      # Allow administration via the web interface
      browsing = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      defaultShared = true;
    };

    # Remote printer discovery via mDNS/DNS-SD
    services.avahi = mkIf cfg.avahi {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
        addresses = true;
        domain = true;
      };
    };

    # Install useful utilities for managing printers
    environment.systemPackages = with pkgs; [
      cups-filters
      system-config-printer
    ];

    # Open firewall for printing
    networking.firewall = {
      allowedTCPPorts = [ 631 ];
      allowedUDPPorts = [ 631 ];
    };
  };
}
