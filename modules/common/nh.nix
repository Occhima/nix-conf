{
  config,
  ...
}:
{
  programs.nh = {
    enable = true;

    # flake = ;
    clean = {
      enable = !config.nix.gc.automatic;
      dates = "weekly";
    };

  };
}
