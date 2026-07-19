{
  flake.modules.homeManager.nix-your-shell =
    {
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
