{ ... }:
{
  config.flake.modules.nixos.nh =
    { config, ... }:
    {
      programs.nh = {
        enable = true;

        # flake = config.modules.home.flakePath;
        clean = {
          enable = !config.nix.gc.automatic;
          dates = "weekly";
        };

      };
    };
}
