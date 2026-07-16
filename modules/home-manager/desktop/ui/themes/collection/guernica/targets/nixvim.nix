{ ... }:
{
  config.flake.modules.homeManager.themes-guernica =
    {
      ...
    }:
    {
      # Maybe I'll want nvim to manage its colorscheme and opacity itself
      stylix.targets.nixvim.enable = false;
    };
}
