{ ... }:
{
  config.flake.modules.nixos.microvm-config =
    {
      config,
      inputs,
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
