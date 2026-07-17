{ ... }:
{
  occhima.themes-guernica.homeManager =
    {
      config,
      ...
    }:
    {
      stylix.targets.gtk = {
        enable = true;
        flatpakSupport.enable = true;
      };

      # gtk.gtk4.theme = config.gtk.theme;
    };
}
