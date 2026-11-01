{
  flake.modules.nixos.boot-kernel =
    { lib, pkgs, ... }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
      boot = {
        kernelPackages = mkDefault pkgs.linuxPackages_latest;
        consoleLogLevel = 3;
        swraid.enable = mkDefault false;

        kernel.sysctl."vm.max_map_count" = 2147483642;

        tmp = {
          useTmpfs = true;
          tmpfsSize = mkDefault "75%";
        };

        initrd = {
          kernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "btrfs"
            "sd_mod"
            "dm_mod"
          ];

          availableKernelModules = [
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
        };

        kernelParams = [
          "pti=auto"
          "idle=nomwait"
          "iommu=pt"
          "usbcore.autosuspend=-1"
          "noresume"
          "acpi_backlight=native"
          "fbcon=nodefer"
          "logo.nologo"
          "vt.global_cursor_default=0"

          "quiet"
          "loglevel=3"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"
        ];
      };
    };
}
