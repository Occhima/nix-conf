{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib;
let
  inherit (lib.modules) mkForce;
  enabled = (config.modules.device.type == "wsl");
in

{
  ##############################
  # Conditional Imports
  ##############################
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  ##############################
  # Conditional Configuration
  ##############################
  config = mkIf enabled {

    # WSL-specific settings.
    wsl = {
      enable = true;
      # defaultUser = config.garden.system.mainUser;
      startMenuLaunchers = true;
      interop = {
        includePath = false;
        register = true;
      };
    };

    # Disable services and features that don't work or aren't needed in WSL.
    services.smartd.enable = mkForce false;
    services.xserver.enable = mkForce false;
    networking.tcpcrypt.enable = mkForce false;
    services.resolved.enable = mkForce false;
    security.apparmor.enable = mkForce false;

    # Setup environment variables and packages for Windows interoperability.
    environment = {
      variables.BROWSER = mkForce "wsl-open";
      systemPackages = [ pkgs.wsl-open ];
    };
  };
}
