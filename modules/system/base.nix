# modules/system/base.nix
{
  ...
}: {
  # Basic system configuration
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "UTC";
}
