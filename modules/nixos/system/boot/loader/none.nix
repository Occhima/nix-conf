{ ... }:
{
  config.flake.modules.nixos.boot-none =
    { lib, config, ... }:
    let
      inherit (lib.modules) mkForce;
    in
    {
      config = {
        boot.loader = {
          grub.enable = mkForce false;
          systemd-boot.enable = mkForce false;
        };
      };
    };
}
