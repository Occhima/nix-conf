{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.meta) getExe';
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;

  cfg = config.modules.system.boot.plymouth;
in
{
  options.modules.system.boot.plymouth = {
    enable = mkOption {
      type = bool;
      default = true;
      description = "Enable plymouth boot splash";
    };
  };

  config = mkIf cfg.enable {
    boot.plymouth.enable = true;

    # Make plymouth work with sleep
    powerManagement = {
      powerDownCommands = "${getExe' pkgs.plymouth "plymouth"} --show-splash";
      resumeCommands = "${getExe' pkgs.plymouth "plymouth"} --quit";
    };
  };
}
