{ ... }:
{
  flake.modules.homeManager.nix-your-shell =
    {
      config,
      ...
    }:
    {
      config = {
        programs.nix-your-shell = {
          enable = true;
        };
      };
    };
}
