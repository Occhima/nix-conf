{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault mkForce;
  inherit (lib) mkOption types;

  cfg = config.modules.network;
in
{
  options.modules.network = {
    enable = lib.mkEnableOption "network configuration";

    hostName = mkOption {
      type = types.str;
      description = "Hostname of the machine";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      hostId = builtins.substring 0 8 (builtins.hashString "md5" cfg.hostName);

      useDHCP = mkForce false;
      useNetworkd = mkForce true;

      usePredictableInterfaceNames = mkDefault true;

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
        "9.9.9.9"
      ];

      enableIPv6 = true;
    };

    services.resolved.enable = true;

    systemd = {
      network.wait-online.enable = false;

      services = {
        NetworkManager-wait-online.enable = false;
        systemd-networkd.stopIfChanged = false;
        systemd-resolved.stopIfChanged = false;
      };
    };
  };
}
