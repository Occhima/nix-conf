{
  devices.disk = {

    ssd = {

      # KINGSTON 480 GB
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B7784F23C10";

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
              extraArgs = [
                "-n"
                "BOOT"
              ]; # label = BOOT
            };
          };

          root = {
            # root + /nix
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "noatime" ];
              extraArgs = [
                "-L"
                "ROOT"
              ]; # label = ROOT
            };
          };
        };
      };
    };

    hdd = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD10EZEX-21WN4A0_WCC6Y7VYE70H";

      content = {
        type = "gpt";
        partitions.home = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/home";
            mountOptions = [ "noatime" ];
            extraArgs = [
              "-L"
              "HOME"
            ]; # label = HOME
          };
        };
      };
    };
  };
}
