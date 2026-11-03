{
  flake.modules.homeManager.themes-guernica-kitty = { config, ... }: {
    # Override font and theme settings conditionally
    programs.kitty = {
      font.name = config.stylix.fonts.monospace.name;
      themeFile = "Monokai_Soda";
    };
  };
}
