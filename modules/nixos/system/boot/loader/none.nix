{ lib, config, ... }:
let
  inherit (lib.modules) mkIf mkForce;
  cfg = config.modules.system.boot.loader;
in
{
  config = mkIf (cfg.type == "none") {
    boot.loader = {
      grub.enable = mkForce false;
      systemd-boot.enable = mkForce false;
    };
  };
}
