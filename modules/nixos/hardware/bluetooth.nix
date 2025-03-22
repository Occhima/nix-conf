{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption "Bluetooth support";
    gui = mkEnableOption "Enable GUI bluetooth manager (blueman)";
    autoReset = mkEnableOption "Auto-reset bluetooth on resume from sleep";
  };

  config = mkIf cfg.enable {
    # Load btusb kernel module for bluetooth
    boot.kernelModules = [ "btusb" ];

    # Enable bluetooth
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
      disabledPlugins = [ "sap" ];
      settings = {
        General = {
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    # Enable blueman GUI if requested
    services.blueman.enable = cfg.gui;

    # Add auto-reset on resume to fix bluetooth reconnection issues
    powerManagement.resumeCommands = mkIf cfg.autoReset ''
      ${pkgs.util-linux}/bin/rfkill block bluetooth
      ${pkgs.util-linux}/bin/rfkill unblock bluetooth
    '';
  };
}
