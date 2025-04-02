{
  lib,
  pkgs,
  inputs,
  config,
  self,
  ...
}:
let
  inherit (lib.modules) mkForce mkIf;
  inherit (self.lib.custom) hasProfile;
in

{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  config = mkIf (hasProfile config [ "wsl" ]) {

    # WSL-specific settings.
    wsl = {
      enable = true;
      defaultUser = "occhima";
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
