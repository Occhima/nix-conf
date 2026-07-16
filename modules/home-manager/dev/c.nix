{ ... }:
{
  config.flake.modules.homeManager.c = (
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          gcc
        ];
      };
    }
  );
}
