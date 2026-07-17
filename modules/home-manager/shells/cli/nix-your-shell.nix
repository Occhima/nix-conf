{ ... }:
{
  occhima.nix-your-shell.homeManager = (
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
    }
  );
}
