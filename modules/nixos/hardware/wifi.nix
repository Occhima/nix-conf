{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.hardware.wifi;
in
{
  options.modules.hardware.wifi = {
    enable = mkEnableOption "WiFi support";

    interfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of WiFi interfaces";
    };
  };

  config = mkIf cfg.enable {
    # Required packages for WiFi
    environment.systemPackages = with pkgs; [
      wpa_supplicant # for wpa_cli
    ];

    # Configure supplicant for each interface
    networking.supplicant = listToAttrs (
      map (
        int:
        nameValuePair int {
          # Allow wpa_(cli|gui) to modify networks list
          userControlled = {
            enable = true;
            group = "users";
          };
          configFile = {
            path = "/etc/wpa_supplicant.d/${int}.conf";
            writable = true;
          };
          extraConf = ''
            ap_scan=1
            p2p_disabled=1
            okc=1
          '';
        }
      ) cfg.interfaces
    );

    # Setup directories and config files
    systemd.tmpfiles.rules = [
      "d /etc/wpa_supplicant.d 700 root root - -"
    ] ++ (map (int: "f /etc/wpa_supplicant.d/${int}.conf 700 root root - -") cfg.interfaces);

    # Ignore these interfaces for network-online.target to avoid delays
    systemd.network.wait-online.ignoredInterfaces = cfg.interfaces;
    boot.initrd.systemd.network.wait-online.ignoredInterfaces = cfg.interfaces;
  };
}
