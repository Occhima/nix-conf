# Disko layout for aerodynamic: standalone `diskoConfigurations.aerodynamic` output
# (for `disko --flake .#aerodynamic`) and the `disko-aerodynamic` NixOS aspect the
# host imports.
{ config, ... }:
let
  layout = {
    devices.disk.system = {
      type = "disk";
      device = "/dev/nvme0n1";

      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

  };
in
{
  flake.diskoConfigurations.aerodynamic = layout;

  flake.modules.nixos.disko-aerodynamic = {
    imports = [ config.flake.modules.nixos.disko-base ];
    disko.devices = layout.devices;
  };
}
