{
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum;
in
{
  options.modules.system.boot.loader.type = mkOption {
    type = enum [
      "none"
      "grub"
      "systemd-boot"
    ];
    default = "none";
    description = "The bootloader to use for the system";
  };
}
