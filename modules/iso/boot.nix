{ lib, ... }:
let
  inherit (lib.modules) mkForce mkAfter;
in
{

  boot = {
    kernelParams = mkAfter [
      "noquiet"
      "toram"
    ];

    loader.systemd-boot.enable = mkForce false;
    swraid.enable = mkForce false;
    supportedFilesystems = mkForce [
      "btrfs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
    ];
  };
}
