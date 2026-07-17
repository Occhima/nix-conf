{ ... }:
{
  occhima.system-config.nixos =
    { lib, ... }:
    {
      system.stateVersion = lib.mkDefault "25.05";
    };
}
