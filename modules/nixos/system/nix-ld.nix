{ ... }:
{
  config.occhima.nix-ld.nixos =
    {
      config,
      ...
    }:

    {
      options.modules.system.nix-ld = {
      };

      config = {
        programs.nix-ld = {
          enable = true;
        };
      };
    };
}
