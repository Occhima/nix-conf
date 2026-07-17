{ inputs, ... }:
{
  config.occhima.microvm-config.nixos =
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
