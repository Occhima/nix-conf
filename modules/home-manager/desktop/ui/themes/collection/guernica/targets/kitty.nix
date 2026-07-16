{ ... }:
{
  config.flake.modules.homeManager.themes-guernica =
    {
      config,
      ...
    }:
    {
      # Disable stylix integration for kitty conditionally
      stylix.targets.kitty.enable = false;

      # Override font and theme settings conditionally
      programs.kitty = {
        font.name = config.stylix.fonts.monospace.name;
        themeFile = "Monokai_Soda";
      };
    };
}
