{
  config,
  ...
}:
{
  programs.nh = {
    enable = true;

    # flake = config.modules.home.flakePath;
    clean = {
      enable = !config.nix.gc.automatic;
      dates = "weekly";
    };

  };
}
