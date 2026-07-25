{
  flake.modules.nixos.boot-none =
    { lib, ... }:
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
