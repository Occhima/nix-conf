{ inputs, ... }:
{
  flake-file.inputs.nixos-wsl = {
    url = "github:nix-community/NixOS-WSL";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.wsl =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.modules) mkForce;
    in
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl
      ];

      config = {
        # WSL-specific settings.
        wsl = {
          enable = true;
          defaultUser = "occhima";
          startMenuLaunchers = true;
          interop = {

            includePath = false;
            register = true;
          };
        };

        # Disable services and features that don't work or aren't needed in WSL.
        services.smartd.enable = mkForce false;
        services.xserver.enable = mkForce false;
        networking.tcpcrypt.enable = mkForce false;
        services.resolved.enable = mkForce false;

        # WSL generates resolv.conf itself (mirrors Windows DNS, VPN-aware);
        # the network aspect's custom nameservers would be ignored and only
        # trigger the NixOS-WSL warning.
        networking.nameservers = mkForce [ ];
        security.apparmor.enable = mkForce false;

        # Setup environment variables and packages for Windows interoperability.
        environment = {
          variables.BROWSER = mkForce "wsl-open";
          systemPackages = [ pkgs.wsl-open ];
        };
      };
    };
}
