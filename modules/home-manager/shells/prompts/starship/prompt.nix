{ ... }:
{
  config.occhima.prompt-starship.homeManager = (
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) importTOML;
    in
    {
      config = {
        programs.starship = {
          package = pkgs.starship;
          enable = true;

          # is this file to big?
          settings = importTOML ./starship.toml;
        };
      };
    }
  );
}
