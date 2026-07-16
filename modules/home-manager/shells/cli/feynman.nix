{ ... }:
{
  config.flake.modules.homeManager.feynman = (
    {
      config,
      pkgs,
      self,
      ...
    }:
    let
      pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.feynman;
    in
    {
      config = {
        home.packages = [ pkg ];
      };
    }
  );
}
