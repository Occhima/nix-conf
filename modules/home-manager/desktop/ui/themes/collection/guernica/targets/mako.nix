{
  flake.modules.homeManager.themes-guernica =
    { config, ... }:
    let
      inherit (config.lib.stylix) colors;
    in
    {
      stylix.targets.mako.enable = false;

      services.mako.settings = {
        font = "${config.stylix.fonts.monospace.name} 11";
        anchor = "top-right";
        layer = "overlay";

        width = 360;
        height = 140;
        outer-margin = "12,18";
        margin = "8";
        padding = "14,16";

        background-color = "#${colors.base00}F2";
        text-color = "#${colors.base05}FF";
        border-size = 1;
        border-color = "#${colors.base02}FF";
        border-radius = 14;
        progress-color = "over #${colors.base0D}FF";

        icons = true;
        icon-location = "left";
        icon-border-radius = 10;
        max-icon-size = 48;
        markup = true;
        actions = true;
        format = "<b>%s</b>\\n%b";

        default-timeout = 6000;
        ignore-timeout = true;
        max-visible = 4;
        max-history = 20;
        sort = "-time";

        on-button-left = "invoke-default-action";
        on-button-right = "dismiss";
      };
    };
}
