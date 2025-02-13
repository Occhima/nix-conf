# modules/system/networking.nix
{ ... }:
{
  networking.useDHCP = false;
  networking.interfaces."enp0s25".useDHCP = true;
}
