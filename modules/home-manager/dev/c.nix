{
  flake.modules.homeManager.c =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          gcc
        ];
      };
    };
}
