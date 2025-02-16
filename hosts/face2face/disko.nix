{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              extraArgs = [
                "-n"
                "boot"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [
                "-L"
                "nixos"
              ];
            };
          };
        };
      };
    };
  };
}
