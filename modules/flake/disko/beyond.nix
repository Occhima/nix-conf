# Disko layout for beyond: standalone `diskoConfigurations.beyond` output
# (for `disko --flake .#beyond`) and the `disko-beyond` NixOS aspect the
# host imports.
{ config, ... }:
let
  layout = {
    devices.disk = {
      ssd = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
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
                type = "luks";
                name = "cryptroot";
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
in
{
  flake.diskoConfigurations.beyond = layout;

  flake.modules.nixos.disko-beyond = {
    imports = [ config.flake.modules.nixos.disko-base ];
    disko.devices = layout.devices;
  };
}
