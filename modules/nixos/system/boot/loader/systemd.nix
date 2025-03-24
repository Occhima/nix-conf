{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) int;

  cfg = config.modules.system.boot.loader;
in
{

  options.modules.system.boot.loader.systemd = {
    memtest = {
      enable = mkEnableOption "memtest86+";
      package = mkPackageOption pkgs "memtest86plus" { };
    };

    configurationLimit = mkOption {
      type = int;
      default = 15;
      description = "Maximum number of configurations in boot menu";
    };
  };

  config = mkIf (cfg.type == "systemd-boot") {
    boot.loader.systemd-boot = mkMerge [
      {
        enable = true;
        configurationLimit = cfg.systemd.configurationLimit;
        consoleMode = "max";
        editor = false;
      }

      (mkIf cfg.systemd.memtest.enable {
        extraFiles = {
          "efi/memtest86plus/memtest.efi" = "${cfg.systemd.memtest.package}/memtest.efi";
        };

        extraEntries = {
          "memtest86plus.conf" = ''
            title MemTest86+
            efi   /efi/memtest86plus/memtest.efi
          '';
        };
      })
    ];
  };
}
