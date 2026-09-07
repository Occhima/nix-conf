# Aggregate: foundational NixOS config imported by all NixOS hosts.
# Contains common modules (nix, nixpkgs, nh, system, environment).
# ponytail: single aggregate module, split if hosts diverge on which common modules they need.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.system-base =
    { config, ... }:
    let
      bootable = config.boot.loader.grub.enable || config.boot.loader.systemd-boot.enable;
    in
    {
      imports = [
        nixos.nix
        nixos.nixpkgs-config
        nixos.nh
        nixos.system-config
        nixos.environment-console
        nixos.environment-fonts
        nixos.environment-locale
        nixos.environment-packages
      ];

      assertions = [
        {
          assertion =
            if config.wsl.enable or false then
              !bootable
            else
              bootable && config.fileSystems ? "/" && config.fileSystems ? "/boot";
          message = "a host must declare a bootloader, a root filesystem and an ESP (or be WSL)";
        }
      ];
    };
}
