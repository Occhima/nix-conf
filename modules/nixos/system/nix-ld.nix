{
  flake.modules.nixos.nix-ld =
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
