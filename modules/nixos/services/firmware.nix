{ ... }:
{
  config.flake.modules.nixos.firmware =
    {
      config,
      ...
    }:
    {
      options.modules.services.firmware = {
      };

      config = {
        services.fwupd = {
          enable = true;
          daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
        };
      };
    };
}
