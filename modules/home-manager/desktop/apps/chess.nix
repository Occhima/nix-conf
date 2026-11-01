{
  flake.modules.homeManager.chess =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          en-croissant
        ];
      };
    };
}
