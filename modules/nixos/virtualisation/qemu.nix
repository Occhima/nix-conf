{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.virtualisation.qemu;
in
{
  options.modules.virtualisation.qemu = {
    enable = mkEnableOption "QEMU/KVM virtualization";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    virtualisation.kvmgt.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
    ];
  };
}
