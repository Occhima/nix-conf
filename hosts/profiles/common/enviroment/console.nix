{ lib, ... }:
{
  console = {
    enable = lib.modules.mkDefault true;
    earlySetup = true;
  };
}
