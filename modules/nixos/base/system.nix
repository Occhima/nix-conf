{
  flake.modules.nixos.system-config =
    { lib, ... }:
    {
      system.stateVersion = lib.mkDefault "25.05";
    };
}
