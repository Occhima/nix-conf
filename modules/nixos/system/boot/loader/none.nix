{ ... }:
{
  config.occhima.boot-none.nixos =
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
