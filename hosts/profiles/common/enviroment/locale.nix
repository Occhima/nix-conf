{ lib, ... }:
{
  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    supportedLocales = lib.modules.mkDefault [
      "en_US.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
    ];
  };
}
