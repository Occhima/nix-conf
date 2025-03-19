{ lib, ... }:
let
  inherit (lib.modules) mkForce;
in
{
  # use networkmanager in the live environment
  networking.networkmanager = {
    enable = true;
    # we don't want any plugins, they only takeup space
    # you might consider adding some if you need a VPN for example
    plugins = mkForce [ ];
  };

  networking.wireless.enable = mkForce false;

  # allow ssh into the system for headless installs
  systemd.services.sshd.wantedBy = mkForce [ "multi-user.target" ];
}
