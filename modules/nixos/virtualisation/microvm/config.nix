{ inputs, ... }:
{
  flake-file.inputs.microvm = {
    url = "github:astro/microvm.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  occhima.microvm-config.nixos =
    {
      config,
      ...
    }:
    {
      options.modules.virtualisation.microvm = {
      };

      imports = [ inputs.microvm.nixosModules.host ];

      config = {

      };
    };
}
