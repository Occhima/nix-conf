{
  flake.modules.homeManager.themes-guernica =
    { ... }:
    {
      stylix.targets.gtk = {
        enable = true;
        flatpakSupport.enable = true;
      };

      # gtk.gtk4.theme = config.gtk.theme;
    };
}
