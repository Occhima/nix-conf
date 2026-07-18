# Disko layout used by VM variants (`run-vm`): every disko host swaps
# to this layout inside `vmVariantWithDisko` (see the disko-base aspect).
{ ... }:
let
  layout = {
    devices = {
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
  };
in
{
  flake.diskoConfigurations.face2face = layout;
}
