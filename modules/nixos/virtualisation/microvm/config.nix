{ inputs, ... }:
{
  config.flake.modules.nixos.microvm-config =
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
