{ ... }:
{
  flake.modules.homeManager.themes-guernica =
    {
      ...
    }:
    {
      stylix.targets.emacs.enable = false;
    };
}
