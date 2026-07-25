# nh (nix helper) for both classes: NixOS hosts and standalone homes.
{
  flake.modules.nixos.nh = { config, ... }: {
    programs.nh = {
      enable = true;

      # flake = config.modules.home.flakePath;
      clean = {
        enable = !config.nix.gc.automatic;
        dates = "weekly";
      };
    };
  };

  # Standalone homes have no NixOS nh/gc; let nh clean the user profile.
  flake.modules.homeManager.nh = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
