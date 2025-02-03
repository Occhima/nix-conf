{ lib, ... }:
let
  inherit (lib.types) enum;
  inherit (lib.options) mkOption;
in
{
  options.modules.device.type = mkOption {
    type = enum [
      "laptop"
      "desktop"
      "server"
      "hybrid"
      "wsl"
      "lite"
      "vm"
    ];
    default = "";
  };
}
