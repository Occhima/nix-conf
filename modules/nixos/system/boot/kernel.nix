{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault mkMerge;
  inherit (lib.lists) optionals;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool raw;

  cfg = config.modules.system.boot.kernel;
in
{
  options.modules.system.boot.kernel = {
    enableKernelTweaks = mkOption {
      type = bool;
      default = true;
      description = "Enable security and performance kernel parameters";
    };

    loadRecommendedModules = mkOption {
      type = bool;
      default = true;
      description = "Load kernel modules for common use cases";
    };

    tmpOnTmpfs = mkOption {
      type = bool;
      default = true;
      description = "Mount /tmp on tmpfs";
    };

    silentBoot = mkOption {
      type = bool;
      default = true;
      description = "Enable silent boot process";
    };

    package = mkOption {
      type = raw;
      default = pkgs.linuxPackages_latest;
      description = "Kernel package to use";
    };

    initrd = {
      enableTweaks = mkOption {
        type = bool;
        default = true;
        description = "Enable initrd optimizations";
      };

      optimizeCompressor = mkOption {
        type = bool;
        default = false;
        description = "Optimize initrd compression (slower compression, smaller size)";
      };
    };
  };

  config = {
    boot = {
      kernelPackages = mkDefault cfg.package;
      consoleLogLevel = mkIf cfg.silentBoot 3;
      swraid.enable = mkDefault false;

      kernel.sysctl."vm.max_map_count" = 2147483642;

      tmp = {
        useTmpfs = cfg.tmpOnTmpfs;
        cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
        tmpfsSize = mkDefault "75%";
      };

      initrd = mkMerge [
        (mkIf cfg.initrd.enableTweaks {
          verbose = false;
          systemd = {
            enable = true;
            strip = true;
          };

          kernelModules = mkIf cfg.loadRecommendedModules [
            "nvme"
            "xhci_pci"
            "ahci"
            "btrfs"
            "sd_mod"
            "dm_mod"
          ];

          availableKernelModules = mkIf cfg.loadRecommendedModules [
            "vmd"
            "usbhid"
            "sd_mod"
            "sr_mod"
            "dm_mod"
            "uas"
            "usb_storage"
            "rtsx_usb_sdmmc"
            "rtsx_pci_sdmmc"
            "ata_piix"
            "virtio_pci"
            "virtio_scsi"
            "ehci_pci"
          ];
        })

        (mkIf cfg.initrd.optimizeCompressor {
          compressor = "zstd";
          compressorArgs = [
            "-19"
            "-T0"
          ];
        })
      ];

      kernelParams =
        (optionals cfg.enableKernelTweaks [
          "pti=auto"
          "idle=nomwait"
          "iommu=pt"
          "usbcore.autosuspend=-1"
          "noresume"
          "acpi_backlight=native"
          "fbcon=nodefer"
          "logo.nologo"
          "vt.global_cursor_default=0"
        ])
        ++ (optionals cfg.silentBoot [
          "quiet"
          "loglevel=3"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"
        ]);
    };
  };
}
