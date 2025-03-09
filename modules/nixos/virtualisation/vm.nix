{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.modules.virtualisation.vm;
  hasDiskoConfig = config ? disko;
  vmVariantAttr = if hasDiskoConfig then "vmVariantWithDisko" else "vmVariant";
in
{
  options.modules.virtualisation.vm = {
    enable = mkEnableOption "Configure system as VM guest";
    memorySize = mkOption {
      type = types.int;
      default = 2048;
      description = "Memory size for the VM in MB";
    };
    diskSize = mkOption {
      type = types.int;
      default = 10240;
      description = "Disk size for the VM in MB";
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    boot.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
    ];

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    virtualisation = {
      ${vmVariantAttr} = {
        virtualisation = {
          memorySize = cfg.memorySize;
          diskSize = cfg.diskSize;
        };
      };
    };
  };
}
