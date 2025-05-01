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
    boot.kernelModules = [ "btusb" ];
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

    environment.systemPackages = [ pkgs.bluetui ];
    services.blueman.enable = cfg.gui;
    powerManagement.resumeCommands = mkIf cfg.autoReset ''
      ${pkgs.util-linux}/bin/rfkill block bluetooth
      ${pkgs.util-linux}/bin/rfkill unblock bluetooth
    '';
  };
}
