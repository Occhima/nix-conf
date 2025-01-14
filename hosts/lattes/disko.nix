{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      system = {
        device = "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt"; # Specify GPT partition table
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem"; # EFI partition type
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # Root partition with the rest of the disk
            root = {
              size = "95%"; # Adjust size to leave space for swap type = "8304";       # Linux x86-64 root GUID
              content = {
                type = "filesystem"; # EFI partition type
                format = "ext4"; # or btrfs, if you prefer
                mountpoint = "/";
              };
            };
            # Swap partition
            swap = {
              size = "5%";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true; # resume from hiberation from this device
              };
            };
          };
        };
      };

      homeDisk = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt"; # Specify GPT partition table
          partitions = {
            home = {
              size = "100%";
              content = {
                type = "filesystem"; # Linux filesystem
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
  };
}
