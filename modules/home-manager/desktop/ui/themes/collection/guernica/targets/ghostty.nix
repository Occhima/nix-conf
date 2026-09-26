{
  flake.modules.homeManager.themes-guernica = { config, ... }: {
    stylix.targets.ghostty.enable = false;

    # Same font and colour scheme as the kitty target.
    programs.ghostty.settings = {
      font-family = config.stylix.fonts.monospace.name;
      theme = "Monokai Soda";
      cursor-style-blink = true;
      cursor-style = "block";
      font-feature = "+liga";
    };
  };
}
