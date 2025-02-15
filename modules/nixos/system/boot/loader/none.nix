{ lib, config, ... }:
let
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.options) mkEnableOption;
  cfg = config.modules.system.boot.loader.none;
in
{

  options.modules.system.boot.loader.none = {
    enable = mkEnableOption "Enable no boot loader";

  };
  config = mkIf cfg.enable {
    boot.loader = {
      grub.enable = mkForce false;
      systemd-boot.enable = mkForce false;
    };
  };
}
