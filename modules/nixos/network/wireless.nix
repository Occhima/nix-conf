{
  lib,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.modules.network.wireless;
in
{
  options.modules.network.wireless = {
    enable = mkEnableOption "wireless networking";

    backend = mkOption {
      type = types.enum [
        "iwd"
        "wpa_supplicant"
      ];
      default = "wpa_supplicant";
      description = "Backend for wireless networking";
    };
  };

  config = mkIf cfg.enable {
    hardware.wirelessRegulatoryDatabase = true;

    networking.wireless = {
      enable = cfg.backend == "wpa_supplicant";
      userControlled = true;
      allowAuxiliaryImperativeNetworks = true;

      extraConfig = ''
        update_config=1
      '';

      iwd = {
        enable = cfg.backend == "iwd";

        settings = {
          Settings.AutoConnect = true;

          General = {
            EnableNetworkConfiguration = true;
            RoamRetryInterval = 15;
          };

          Network = {
            EnableIPv6 = true;
            RoutePriorityOffset = 300;
          };
        };
      };
    };
  };
}
