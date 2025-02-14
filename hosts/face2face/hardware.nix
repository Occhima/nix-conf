{

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  boot.loader = {
    grub.enable = true;
    grub.device = "/dev/sda"; # or "nodev" for EFI only
    timeout = 0; # Instant boot, no menu
  };

  # Disable bootloader splash and graphics
  boot.kernelParams = [
    "quiet"
    "nomodeset"
    "console=tty1"
    "console=ttyS0,115200n8"
  ];
}
