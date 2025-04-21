{
  devices.disk.system = {
    type = "disk";
    device = "/dev/nvme0n1";

    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "550M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "FAT32";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            mountpoint = "/";
            mountOptions = [
              "compress=zstd"
              "noatime"
              "ssd"
            ];
            subvolumes = {
              "@root" = {
                mountpoint = "/";
              };
              "@home" = {
                mountpoint = "/home";
              };
              "@nix" = {
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
  };

}
