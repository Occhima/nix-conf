{ ... }:
{
  config.flake.modules.homeManager.antigravity = (
    {
      config,
      self,
      pkgs,
      ...
    }:
    {
      config = {
        home = {
          packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.antigravity ];
        };
      };
    }
  );
}
