# modules/system/networking.nix
{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "my-host";
  networking.useDHCP = false;
  networking.interfaces."enp0s25".useDHCP = true;
}
