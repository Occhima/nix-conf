{ ... }:
{
  occhima.boot-systemd.nixos =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.modules) mkIf mkMerge;
      inherit (lib.options) mkOption mkPackageOption;
      inherit (lib.types) int;

      cfg = config.modules.system.boot.loader;
    in
    {

      options.modules.system.boot.loader.systemd = {
        memtest = {
          package = mkPackageOption pkgs "memtest86plus" { };
        };

        configurationLimit = mkOption {
          type = int;
          default = 15;
          description = "Maximum number of configurations in boot menu";
        };
      };

      config = {
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
    };
}
