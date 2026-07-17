{ ... }:
{
  flake.modules.homeManager.themes-guernica =
    {
      config,
      ...
    }:
    {
      stylix.targets.mako.enable = false;

      services.mako = {
        settings = {
          font = config.stylix.fonts.monospace.name;
          anchor = "top-right";
          background-color = "#000000FF";
          padding = "10";
          border-size = 1;
          border-color = "#9F9F9FFF";
          margin = "18";
          border-radius = 10;
          max-icon-size = 52;
        };
      };
    };
}
