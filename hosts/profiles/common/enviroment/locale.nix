{ lib, ... }:
{
  time = {
    timeZone = "America/New_York";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = lib.modules.mkDefault [
      "en_US.UTF-8/UTF-8"
    ];
  };
}
