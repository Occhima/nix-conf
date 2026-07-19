{
  flake.modules.nixos.nix-ld =
    {
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
