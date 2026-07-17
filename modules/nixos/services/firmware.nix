{ ... }:
{
  config.occhima.firmware.nixos =
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
