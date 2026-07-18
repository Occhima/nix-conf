{
  flake.modules.homeManager.themes-guernica =
    {
      config,
      ...
    }:
    {
      stylix.targets.kitty.enable = false;

      programs.ghostty = {
        settings = {
          font-family = config.stylix.fonts.monospace.name;
          cursor-style-blink = true;
          cursor-style = "block";
          font-feature = "+liga";
        };
      };
    };
}
